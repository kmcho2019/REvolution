module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] diff;

always @(posedge clk) begin
    prev_in <= in;  // Update the previous state
end

always @(posedge clk) begin
    diff <= in ^ prev_in;  // Differential stage
    anyedge <= diff;  // Edge detection stage
end

endmodule