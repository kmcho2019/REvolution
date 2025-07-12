module right_shifter(
    input clk,
    input d,
    output reg [7:0] q = 8'b0
);

    reg [7:0] buffer;

    always @(posedge clk) begin
        buffer[7] <= d;
        for (int i = 6; i >= 0; i--) begin
            buffer[i] <= buffer[i + 1];
        end
        q <= buffer;
    end

endmodule