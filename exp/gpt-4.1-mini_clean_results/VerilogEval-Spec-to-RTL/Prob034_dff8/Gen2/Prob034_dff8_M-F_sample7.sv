module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    initial begin
        q = 8'b0; // Initialize q to avoid unknown state at simulation start
    end

    always @(posedge clk) begin
        q <= d;
    end

endmodule