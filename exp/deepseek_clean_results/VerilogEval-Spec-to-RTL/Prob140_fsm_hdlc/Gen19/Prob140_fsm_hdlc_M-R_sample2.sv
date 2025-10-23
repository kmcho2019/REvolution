module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot state encoding
    reg [7:0] state;
    wire [7:0] next_state;

    // State definitions
    parameter S0 = 8'b00000001;  // 0 consecutive 1s
    parameter S1 = 8'b00000010;  // 1 consecutive 1
    parameter S2 = 8'b00000100;  // 2 consecutive 1s
    parameter S3 = 8'b00001000;  // 3 consecutive 1s
    parameter S4 = 8'b00010000;  // 4 consecutive 1s
    parameter S5 = 8'b00100000;  // 5 consecutive 1s
    parameter S6 = 8'b01000000;  // 6 consecutive 1s
    parameter S7 = 8'b10000000;  // 7+ consecutive 1s (error)

    // Next state logic
    assign next_state = reset ? S0 :
                      in ? (state == S7 ? S7 :
                           {state[6:0], 1'b0}) :
                      S0;

    // State register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic (combinational)
    assign disc = (state == S5) & ~in;
    assign flag = (state == S6) & ~in;
    assign err = (state == S7);

endmodule