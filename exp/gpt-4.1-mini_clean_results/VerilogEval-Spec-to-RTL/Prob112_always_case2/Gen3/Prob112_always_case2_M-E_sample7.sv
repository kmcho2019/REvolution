module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

wire [3:0] one_hot;
wire [3:0] masked;

// Decode input bits to one-hot signals
assign one_hot = in;

// Mask each bit by ANDing with inverse of all higher-priority bits
assign masked[0] = one_hot[0];
assign masked[1] = one_hot[1] & ~one_hot[0];
assign masked[2] = one_hot[2] & ~one_hot[1] & ~one_hot[0];
assign masked[3] = one_hot[3] & ~one_hot[2] & ~one_hot[1] & ~one_hot[0];

always @(*) begin
    case (masked)
        4'b0001: pos = 2'd0;
        4'b0010: pos = 2'd1;
        4'b0100: pos = 2'd2;
        4'b1000: pos = 2'd3;
        default: pos = 2'd0; // no bits set
    endcase
end

endmodule