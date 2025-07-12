module TopModule(
    input clk,
    input rst_n,      // Active-low asynchronous reset
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 8'b0;   // Reset outputs to zero
        else
            q <= d;
    end

endmodule