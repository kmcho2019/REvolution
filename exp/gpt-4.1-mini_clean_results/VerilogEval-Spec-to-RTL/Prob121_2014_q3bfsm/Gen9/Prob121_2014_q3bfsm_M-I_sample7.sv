module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding
    localparam S0 = 5'b00001; // state 000
    localparam S1 = 5'b00010; // state 001
    localparam S2 = 5'b00100; // state 010
    localparam S3 = 5'b01000; // state 011
    localparam S4 = 5'b10000; // state 100

    reg [4:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic integrated: z=1 only in states S3 or S4
    always @(*) begin
        z = (state == S3) || (state == S4);
    end

endmodule