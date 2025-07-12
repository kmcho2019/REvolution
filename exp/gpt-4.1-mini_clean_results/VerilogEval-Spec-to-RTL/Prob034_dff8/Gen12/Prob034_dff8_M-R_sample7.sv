module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    // Parallel load of 8 bits d into q on each positive clock edge.
    always @(posedge clk) begin
        q <= d;
    end

endmodule