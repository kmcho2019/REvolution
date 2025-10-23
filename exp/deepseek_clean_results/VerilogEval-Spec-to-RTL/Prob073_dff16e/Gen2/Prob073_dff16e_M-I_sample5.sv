module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Register byteena signals to improve timing
reg [1:0] byteena_reg;
always @(posedge clk) begin
    byteena_reg <= byteena;
end

// Clock gating logic for power optimization
wire upper_byte_clk_en = byteena_reg[1] && resetn;
wire lower_byte_clk_en = byteena_reg[0] && resetn;

// Separate always blocks for better synthesis optimization
always @(posedge clk) begin
    if (!resetn) begin
        q[15:8] <= 8'b0;
    end else if (upper_byte_clk_en) begin
        q[15:8] <= d[15:8];
    end
end

always @(posedge clk) begin
    if (!resetn) begin
        q[7:0] <= 8'b0;
    end else if (lower_byte_clk_en) begin
        q[7:0] <= d[7:0];
    end
end

endmodule