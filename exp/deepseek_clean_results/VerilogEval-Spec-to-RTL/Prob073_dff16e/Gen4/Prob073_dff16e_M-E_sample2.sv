module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Create byte enable masks
wire [15:0] byte_mask = {
    {8{byteena[1]}},  // Upper byte mask
    {8{byteena[0]}}   // Lower byte mask
};

// Masked input data
wire [15:0] masked_d = d & byte_mask;

// Current value with disabled bytes preserved
wire [15:0] preserved_q = q & ~byte_mask;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        q <= preserved_q | masked_d;  // Combine preserved and new bits
    end
end

endmodule