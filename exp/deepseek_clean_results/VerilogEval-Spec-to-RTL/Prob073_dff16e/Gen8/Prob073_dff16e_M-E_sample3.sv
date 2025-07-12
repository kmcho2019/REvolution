module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

wire [15:0] byte_mask = {
    {8{byteena[1]}},  // Upper byte mask
    {8{byteena[0]}}   // Lower byte mask
};

wire [15:0] masked_d = d & byte_mask;
wire [15:0] current_q = q & ~byte_mask;
wire [15:0] next_q = masked_d | current_q;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        q <= next_q;
    end
end

endmodule