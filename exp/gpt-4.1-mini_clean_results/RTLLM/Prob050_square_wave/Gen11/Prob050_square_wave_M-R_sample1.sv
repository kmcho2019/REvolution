module square_wave (
    input  wire       clk,
    input  wire       rst_n,   // Active low synchronous reset
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;
    wire counting_enabled = (freq != 8'd0);
    wire [7:0] freq_minus_one = freq - 8'd1;
    wire toggle_condition = counting_enabled && (count == freq_minus_one);

    // Next state logic for count and wave_out
    wire [7:0] count_next = (toggle_condition) ? 8'd0 : (count + 8'd1);
    wire       wave_out_next = (toggle_condition) ? ~wave_out : wave_out;

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (counting_enabled) begin
            count    <= count_next;
            wave_out <= wave_out_next;
        end else begin
            // Hold outputs steady when freq = 0
            count    <= 8'd0;
            wave_out <= wave_out;
        end
    end

endmodule