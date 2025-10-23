module TopModule (
    input         clk,
    input         resetn,
    input   [1:0] byteena,
    input  [15:0] d,
    output reg [15:0] q
);

// Generate gated clocks for upper and lower byte registers
wire clk_lower = clk & byteena[0];
wire clk_upper = clk & byteena[1];

// Lower byte registers [7:0]
reg [7:0] q_lower;
always @(posedge clk_lower) begin
    if (!resetn) begin
        q_lower <= 8'b0;
    end else begin
        q_lower <= d[7:0];
    end
end

// Upper byte registers [15:8]
reg [7:0] q_upper;
always @(posedge clk_upper) begin
    if (!resetn) begin
        q_upper <= 8'b0;
    end else begin
        q_upper <= d[15:8];
    end
end

// Combine outputs
always @(*) begin
    q = {q_upper, q_lower};
end

endmodule