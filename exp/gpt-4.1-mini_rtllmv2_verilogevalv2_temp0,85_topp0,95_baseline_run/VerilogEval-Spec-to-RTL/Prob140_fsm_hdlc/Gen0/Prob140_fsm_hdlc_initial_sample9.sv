module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // States represent number of consecutive ones seen: 0 to 6 normal, 7 = error
    reg [3:0] state, next_state;

    // Sequential logic: state update and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs depend on previous state and current input, so outputs are registered after state update
            // But here we use previous state and current input to decide outputs
            // Since state updates on posedge clk, next_state is combinationally computed before posedge clk
            // So outputs reflect conditions based on previous state and current input

            // To meet "outputs asserted for one cycle beginning on the clock cycle after the condition occurs"
            // outputs are assigned from previous combinational conditions:

            // We do outputs combinationally from state and in in next_state logic, then assign outputs in sequential block

            // But since outputs depend on previous input sequence, we calculate outputs combinationally below
            // and latch them here.

            // So we latch outputs computed in combinational block below
            disc <= disc_next;
            flag <= flag_next;
            err  <= err_next;
        end
    end

    // Combinational logic to compute next_state and outputs based on current state and input
    reg disc_next, flag_next, err_next;

    always @(*) begin
        // Default outputs off
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;

        case (state)
            4'd0: begin
                // No consecutive ones
                if (in)
                    next_state = 4'd1;
                else
                    next_state = 4'd0;
            end
            4'd1: begin
                if (in)
                    next_state = 4'd2;
                else begin
                    // Sequence was: 01 -> no special output
                    next_state = 4'd0;
                end
            end
            4'd2: begin
                if (in)
                    next_state = 4'd3;
                else
                    next_state = 4'd0;
            end
            4'd3: begin
                if (in)
                    next_state = 4'd4;
                else
                    next_state = 4'd0;
            end
            4'd4: begin
                if (in)
                    next_state = 4'd5;
                else
                    next_state = 4'd0;
            end
            4'd5: begin
                if (in) 
                    next_state = 4'd6; // 6 consecutive ones now
                else begin
                    // On 0 after 5 consecutive 1s: 0111110 => discard bit
                    disc_next = 1'b1;
                    next_state = 4'd0;
                end
            end
            4'd6: begin
                if (in)
                    next_state = 4'd7; // error state: 7 ones
                else begin
                    // On 0 after 6 consecutive 1s: 01111110 => flag
                    flag_next = 1'b1;
                    next_state = 4'd0;
                end
            end
            4'd7: begin
                // error state: stay here on 1, or reset count on 0?
                // According to spec, error asserted on 7 or more 1s
                err_next = 1'b1;
                if (in)
                    next_state = 4'd7;
                else
                    next_state = 4'd0;
            end
            default: begin
                // default to 0
                next_state = 4'd0;
            end
        endcase
    end

endmodule