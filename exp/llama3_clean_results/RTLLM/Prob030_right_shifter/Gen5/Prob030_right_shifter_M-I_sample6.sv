module right_shifter(
    input clk,
    input rst_n, // Active low reset signal
    input d,
    output reg [7:0] q = 8'b0
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            q <= 8'b0;
        end else begin
            q <= {d, q[7:1]};
        end
    end

endmodule