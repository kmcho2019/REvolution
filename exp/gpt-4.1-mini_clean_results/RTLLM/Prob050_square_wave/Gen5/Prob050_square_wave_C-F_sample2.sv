module square_wave (
    input wire        clk,
    input wire        rst_n,    // Active low synchronous reset
    input wire [7:0]  freq,
    output reg        wave_out
);

    reg [7:0] count;
    wire counting_enabled;
    wire toggle_condition;
    wire [7:0] freq_minus_one;

    assign counting_enabled = (freq != 8'd0);
    assign freq_minus_one = freq - 8'd1;
    assign toggle_condition = counting_enabled && (count == freq_minus_one);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (counting_enabled) begin
            if (toggle_condition) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            // Hold outputs steady when freq = 0
            count    <= 8'd0;
            wave_out <= wave_out;
        end
    end

endmodule