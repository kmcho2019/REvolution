module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        q <= {q[6:0], d[0]};
    end

    // Initialize q with the input d
    initial begin
        q <= d;
    end

endmodule