module square_wave (
    input        clk,
    input        rst,       // Active-high synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire       counting_enable;
    wire       toggle_condition;
    wire [7:0] freq_minus_one;

    assign freq_minus_one = freq - 8'd1;
    assign counting_enable = (freq != 8'd0);
    assign toggle_condition = counting_enable && (count == freq_minus_one);

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (counting_enable) begin
            if (toggle_condition) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end 
        // When freq == 0, hold wave_out and count steady to save power
    end

endmodule