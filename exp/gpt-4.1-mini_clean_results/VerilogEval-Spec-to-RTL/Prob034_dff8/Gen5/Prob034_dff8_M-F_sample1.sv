module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    // Initialize q to 0 to avoid X in simulation startup
    initial begin
        q = 8'b0;
    end

    always @(posedge clk) begin
        q <= d;
    end

endmodule