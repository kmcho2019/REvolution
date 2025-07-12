module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

wire [3:0] masked;

// Create masked one-hot vector where only the highest priority set bit remains
assign masked[0] = in[0];
assign masked[1] = in[1] & ~in[0];
assign masked[2] = in[2] & ~in[1] & ~in[0];
assign masked[3] = in[3] & ~in[2] & ~in[1] & ~in[0];

always @(*) begin
    case (masked)
        4'b0001: pos = 2'd0;
        4'b0010: pos = 2'd1;
        4'b0100: pos = 2'd2;
        4'b1000: pos = 2'd3;
        default: pos = 2'd0; // No bits set
    endcase
end

endmodule