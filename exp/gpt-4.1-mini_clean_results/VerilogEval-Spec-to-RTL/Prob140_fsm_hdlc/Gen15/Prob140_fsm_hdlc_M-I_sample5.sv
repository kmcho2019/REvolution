module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding: count of consecutive ones (0 to 7)
    // 3-bit counter: 0 to 7
    // When count > 6 => error
    // Outputs are generated based on state and input combinationally

    reg [2:0] state, next_state;

    // Next state logic: count consecutive ones or reset on zero input
    always @(*) begin
        if (in == 1'b0) 
            next_state = 3'd0;
        else if (state < 3'd7)
            next_state = state + 3'd1;
        else
            next_state = 3'd7; // saturate at 7 (error)
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Outputs: Moore type - depend only on current state
    // They are asserted for exactly one cycle on the cycle after the condition is met.

    // disc: occurs if previous count was 5 and input 0 (i.e., next_state = 0 after state=5 and in=0)
    // flag: occurs if previous count was 6 and input 0 (i.e., next_state=0 after state=6 and in=0)
    // err: occurs if state >=7 (7 or more consecutive ones)
    //
    // Since state is updated on clock edge, the outputs correspond to previous cycle condition.
    // So disc is asserted when state==0 and previous cycle input was zero after count 5.
    // To track previous condition, detect in combinational logic when disc/flag should assert next cycle,
    // and store outputs as a function of current state.
    //
    // Simplify by generating outputs based on previous state and current input.
    // Since we have only state register, and next_state combinational, we can create output regs registered at clock
    // that pulse when conditions happen. Alternatively, outputs assigned from state variable delayed by one cycle.
    //
    // Here, we generate output signals by remembering the previous state's next_state logic:
    // If previous state == 5 and input == 0 => disc output next cycle (state==0 after next_state update)
    // If previous state == 6 and input == 0 => flag output next cycle (state==0 after next_state update)
    // If state >=7 => err output

    reg disc_r, flag_r, err_r;

    always @(posedge clk) begin
        if (reset) begin
            disc_r <= 1'b0;
            flag_r <= 1'b0;
            err_r  <= 1'b0;
        end else begin
            // disc: previous state 5, input 0 => next_state=0 => state next cycle = 0 => detect disc now
            // flag: previous state 6, input 0 => next_state=0 => state next cycle = 0 => detect flag now
            // To detect disc/flag one cycle after, check if current state == 0 and previous in and state.
            // For this, we need to store previous state's value and input.
            // So add registered previous state and previous input.

            // For synchronous logic, implement two stage registers for state and input:
            // But here, since state is already registered, and input is asynchronous,
            // register input for one cycle to align.

            // Therefore, we create registered versions to detect when disc/flag are asserted.

            disc_r <= (prev_state == 3'd5) && (prev_in == 1'b0);
            flag_r <= (prev_state == 3'd6) && (prev_in == 1'b0);
            err_r  <= (state >= 3'd7);
        end
    end

    reg [2:0] prev_state;
    reg       prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_state <= 3'd0;
            prev_in    <= 1'b0;
        end else begin
            prev_state <= state;
            prev_in    <= in;
        end
    end

    assign disc = disc_r;
    assign flag = flag_r;
    assign err  = err_r;

endmodule