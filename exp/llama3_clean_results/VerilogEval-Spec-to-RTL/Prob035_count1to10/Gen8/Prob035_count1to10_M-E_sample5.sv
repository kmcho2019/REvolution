module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 4'd1;

// Define the lookup table for the counting sequence
reg [3:0] lut [9:0] = {
    4'd2,  // Next state for count = 1
    4'd3,  // Next state for count = 2
    4'd4,  // Next state for count = 3
    4'd5,  // Next state for count = 4
    4'd6,  // Next state for count = 5
    4'd7,  // Next state for count = 6
    4'd8,  // Next state for count = 7
    4'd9,  // Next state for count = 8
    4'd10, // Next state for count = 9
    4'd1   // Next state for count = 10 (reset to 1)
};

always @(posedge clk) begin
    if (reset) count <= 4'd1;
    else count <= lut[count - 1];
end

assign q = count;

endmodule