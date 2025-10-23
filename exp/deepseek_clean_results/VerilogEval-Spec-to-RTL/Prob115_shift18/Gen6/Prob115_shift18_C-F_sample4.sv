module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-computed sign extension masks
wire [63:0] sign_ext_1 = {64{q[63]}} & 64'h8000000000000000;
wire [63:0] sign_ext_8 = {64{q[63]}} & 64'hFF00000000000000;

wire [63:0] next_q;

always @(*) begin
    case ({ena, load, amount})
        {1'b1, 1'b1, 2'b??}: next_q = data;  // Load has priority
        {1'b1, 1'b0, 2'b00}: next_q = q << 1; // Left 1
        {1'b1, 1'b0, 2'b01}: next_q = q << 8; // Left 8
        {1'b1, 1'b0, 2'b10}: next_q = (q >> 1) | sign_ext_1; // Right 1
        {1'b1, 1'b0, 2'b11}: next_q = (q >> 8) | sign_ext_8; // Right 8
        default: next_q = q; // No operation
    endcase
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule