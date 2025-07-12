module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

// States represent count of consecutive ones seen (0 to 6), and err state (7)
typedef enum reg [3:0] {
    S0  = 4'd0, // no consecutive ones
    S1  = 4'd1,
    S2  = 4'd2,
    S3  = 4'd3,
    S4  = 4'd4,
    S5  = 4'd5,
    S6  = 4'd6,
    S_ERR= 4'd7
} state_t;

reg [3:0] state, next_state;

// Outputs are based on previous state and current input pattern and must be registered for one cycle
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc  <= 1'b0;
        flag  <= 1'b0;
        err   <= 1'b0;
    end else begin
        state <= next_state;

        // Update outputs according to current state and input, delayed by one cycle
        // Previous cycle inputs are reflected by current state and current input
        // We assert outputs for one cycle on the cycle after pattern detected

        // disc: exactly 6 consecutive ones then a 0 inserted (pattern 0111110),
        // This means if previous state was S5, and current input is zero, disc next cycle
        // But outputs are registered, so outputs are asserted based on previous cycle pattern.
        //
        // flag: pattern 01111110 means 6 consecutive ones followed by a zero; so previous state S6, input zero.
        //
        // err: 7 or more ones; if previous state S6 and input 1, then err next cycle.

        // So outputs registered on next cycle are generated from previous state and input.

        // But since outputs are updated on clock after state updates, we must track previous state and input.
        // To do this, we store current input and previous state in temporary registers.

        // To keep things simple, let's compute outputs combinationally from previous state and input,
        // and register them on clock.

        // So these assignments are moved outside to combinational logic with temp signals.
    end
end

// To properly generate outputs one cycle after pattern detection, save current input and previous state in regs
reg [3:0] prev_state;
reg       prev_in;

always @(posedge clk) begin
    if (reset) begin
        prev_state <= S0;
        prev_in    <= 1'b0;
    end else begin
        prev_state <= state;
        prev_in    <= in;
    end
end

// Outputs logic combinationally from prev_state and prev_in
wire disc_next = (prev_state == S5) && (prev_in == 1'b0);
wire flag_next = (prev_state == S6) && (prev_in == 1'b0);
wire err_next  = (prev_state == S6) && (prev_in == 1'b1);

always @(posedge clk) begin
    if (reset) begin
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
    end else begin
        disc <= disc_next;
        flag <= flag_next;
        err  <= err_next;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S0: begin
            if (in)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (in)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (in)
                next_state = S3;
            else
                next_state = S0;
        end
        S3: begin
            if (in)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (in)
                next_state = S5;
            else
                next_state = S0;
        end
        S5: begin
            if (in)
                next_state = S6;
            else
                next_state = S0;
        end
        S6: begin
            if (in)
                next_state = S_ERR; // 7 or more ones = error state
            else
                next_state = S0;
        end
        S_ERR: begin
            if (in)
                next_state = S_ERR;
            else
                next_state = S0; // on zero reset count even in error state
        end
        default: next_state = S0;
    endcase
end

endmodule