module square_wave (
    input  wire        clk,
    input  wire        rst,      // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg  [7:0] count;
    wire [7:0] freq_minus_one;
    wire       counting_enabled;
    wire       toggle_condition;

    assign freq_minus_one  = freq - 8'd1;
    assign counting_enabled = (freq != 8'd0);
    assign toggle_condition = counting_enabled && (count == freq_minus_one);

    always @(posedge clk) begin
        if (rst) begin
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
            count    <= 8'd0;     // Hold count at 0 when freq=0
            wave_out <= wave_out; // Hold output steady when freq=0
        end
    end

endmodule