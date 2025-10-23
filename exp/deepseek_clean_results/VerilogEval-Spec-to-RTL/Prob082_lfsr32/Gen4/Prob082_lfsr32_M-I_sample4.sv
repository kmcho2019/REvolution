module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg q0_reg;
wire [31:0] next_q;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
        q0_reg <= 1'b1;
    end
    else begin
        q <= next_q;
        q0_reg <= q[0];
    end
end

// Optimized Galois LFSR implementation
assign next_q = {q0_reg, 
                q[31:23], 
                q[22] ^ q0_reg, 
                q[21:3], 
                q[2] ^ q0_reg, 
                q[1] ^ q0_reg};

endmodule