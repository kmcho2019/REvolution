module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values using binary encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Define the LUTs for next state and output
localparam [1:0] NS_LUT [4][2] = {
    {A, B},  // State A
    {C, B},  // State B
    {A, D},  // State C
    {C, B}   // State D
};

localparam [0:0] OUT_LUT [4] = {
    1'b0,  // State A
    1'b0,  // State B
    1'b0,  // State C
    1'b1   // State D
};

// State register
reg [1:0] state;

// Sequential logic for state update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= NS_LUT[state][in];
    end
end

// Output logic using the OUT_LUT
always @(*) begin
    out = OUT_LUT[state];
end

endmodule