module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

reg q0_reg;  // Registered version of q[0] for timing improvement

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
        q0_reg <= 1'b0;
    end
    else begin
        q0_reg <= q[0];
        q <= {q0_reg, q[4], q[3] ^ q0_reg, q[2], q[1]};
    end
end

endmodule