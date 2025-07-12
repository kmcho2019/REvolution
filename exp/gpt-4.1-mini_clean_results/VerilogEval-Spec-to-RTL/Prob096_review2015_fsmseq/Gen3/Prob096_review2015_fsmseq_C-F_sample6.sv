module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding with localparams for clarity and compatibility
    localparam S0   = 2'd0;  // no match
    localparam S1   = 2'd1;  // matched '1'
    localparam S11  = 2'd2;  // matched '11'
    localparam S110 = 2'd3;  // matched '110'

    reg [1:0] state, next_state;
    reg sequence_found;

    // Next state logic: combinational with default assignment for safety
    always @(*) begin
        next_state = S0;  // default state
        case(state)
            S0:   next_state = data ? S1   : S0;
            S1:   next_state = data ? S11  : S0;
            S11:  next_state = data ? S11  : S110;
            S110: next_state = data ? S1   : S0;  // allows overlapping pattern detection
            default: next_state = S0;
        endcase
    end

    // Detect the sequence '1101' when current state is S110 and input data is 1
    always @(*) begin
        sequence_found = (state == S110) && (data == 1'b1);
    end

    // Sequential logic: state updates and output latching on clock's posedge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (sequence_found)
                start_shifting <= 1'b1;  // latch output permanently until reset
        end
    end

endmodule