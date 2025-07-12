module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

reg [99:0] next_q;

always @(*) begin
    if (load) begin
        next_q = data;
    end else begin
        case (ena)
            2'b01: // rotate right by 1
                next_q = {q[0], q[99:1]};
            2'b10: // rotate left by 1
                next_q = {q[98:0], q[99]};
            default: // 2'b00 or 2'b11 no rotation
                next_q = q;
        endcase
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule