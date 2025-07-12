module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] binary_count;
reg [9:0] gray_count;
wire terminal_count;

// Optimized terminal count detection (999 = 1111100111)
assign terminal_count = &binary_count[9:5] & 
                       ~binary_count[4] & ~binary_count[3] & 
                       binary_count[2] & binary_count[1] & binary_count[0];

// Combinational next-state logic
wire [9:0] next_binary = reset ? 10'b0 : 
                        (terminal_count ? 10'b0 : binary_count + 1'b1);

// Binary to Gray conversion
always @(*) begin
    gray_count = {next_binary[9], 
                 next_binary[9:1] ^ next_binary[8:0]};
end

// Sequential state storage
always @(posedge clk) begin
    binary_count <= next_binary;
end

assign q = gray_count;

endmodule