module square_wave (
    input  wire        clk,
    input  wire        rst_n,       // Active-low synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      count_enable;
    wire [7:0] freq_minus_one;
    wire      toggle_event;

    assign count_enable   = (freq != 8'd0);
    assign freq_minus_one = freq - 8'd1;
    assign toggle_event   = count_enable && (count == freq_minus_one);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (count_enable) begin
            if (toggle_event) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            // Hold count and output steady when freq is zero
            count    <= 8'd0;
            wave_out <= wave_out;
        end
    end

endmodule