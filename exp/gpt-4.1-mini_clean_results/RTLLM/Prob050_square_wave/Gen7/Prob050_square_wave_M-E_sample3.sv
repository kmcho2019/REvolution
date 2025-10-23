module square_wave (
    input        clk,
    input        rst,         // Active high asynchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq != 8'd0) begin
            if (count == 8'd0) begin
                count    <= freq;
                wave_out <= ~wave_out;
            end else begin
                count <= count - 1'b1;
            end
        end else begin
            count <= 8'd0;         // Freeze count when freq is zero
            wave_out <= wave_out;  // Hold wave_out steady
        end
    end

endmodule