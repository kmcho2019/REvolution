module TopModule(clk, reset, q);
    input clk, reset;
    output [4:0] q;
    reg [4:0] q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b10000;
        end else begin
            q <= {q[3] ^ q[0], q[4:1]};
        end
    end

endmodule