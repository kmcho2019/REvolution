module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            // feedback bit: q[0] XOR q[31] XOR q[21] XOR q[1]
            q <= { (q[0] ^ q[31] ^ q[21] ^ q[1]), q[31:1] };
        end
    end

endmodule