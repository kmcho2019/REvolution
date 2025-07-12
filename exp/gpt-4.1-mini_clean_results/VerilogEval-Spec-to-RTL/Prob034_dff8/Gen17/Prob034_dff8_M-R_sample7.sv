module TopModule(
    input clk,
    input rst,        // synchronous reset input
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b0;
        else
            q <= d;
    end

endmodule