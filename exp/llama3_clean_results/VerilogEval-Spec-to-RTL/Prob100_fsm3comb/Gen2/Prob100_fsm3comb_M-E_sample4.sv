module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

    reg [1:0] next_state_LUT [4][2] = {
        {2'b01, 2'b00}, // State A
        {2'b01, 2'b10}, // State B
        {2'b11, 2'b00}, // State C
        {2'b01, 2'b10}  // State D
    };

    reg [0:0] out_LUT [4] = {
        1'b0, // State A
        1'b0, // State B
        1'b0, // State C
        1'b1  // State D
    };

    always @(*) begin
        next_state = next_state_LUT[state][in];
        out = out_LUT[state];
    end

endmodule