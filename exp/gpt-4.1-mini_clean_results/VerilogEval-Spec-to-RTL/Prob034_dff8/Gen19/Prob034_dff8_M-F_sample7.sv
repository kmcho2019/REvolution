module TopModule(
    input clk,
    input rst,         // Added synchronous reset input
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'b0;
        end else begin
            q <= d;
        end
    end

endmodule