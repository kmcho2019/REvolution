module square_wave (
    input        clk,
    input        rst,       // Active high asynchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wave_out <= 1'b0;
            count    <= 8'd0;
        end else if (freq == 8'd0) begin
            // Hold output steady and count zero when freq is zero
            wave_out <= wave_out;
            count    <= 8'd0;
        end else begin
            if (count == 8'd0) begin
                count    <= freq;
                wave_out <= ~wave_out;
            end else begin
                count <= count - 1'b1;
            end
        end
    end

endmodule