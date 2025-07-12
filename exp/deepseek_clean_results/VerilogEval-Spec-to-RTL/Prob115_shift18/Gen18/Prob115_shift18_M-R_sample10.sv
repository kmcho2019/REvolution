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

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        case (amount)
            2'b00: q <= q << 1;  // Left by 1
            2'b01: q <= q << 8;  // Left by 8
            2'b10: q <= (q >> 1) | sign_ext_1;  // Right by 1 (arithmetic)
            2'b11: q <= (q >> 8) | sign_ext_8;  // Right by 8 (arithmetic)
        endcase
    end
end

endmodule