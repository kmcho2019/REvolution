module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

reg q0_reg;
wire q0_next = q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
        q0_reg <= 1'b0;
    end
    else begin
        q0_reg <= q0_next;
        q <= {q0_reg, q[4], q[3] ^ q0_reg, q[2:1]};
    end
end

endmodule