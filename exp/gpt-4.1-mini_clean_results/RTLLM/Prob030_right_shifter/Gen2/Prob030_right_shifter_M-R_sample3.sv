module right_shifter (
    input clk,
    input reset,
    input d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;
        end else begin
            q <= {d, q[7:1]};
        end
    end

endmodule