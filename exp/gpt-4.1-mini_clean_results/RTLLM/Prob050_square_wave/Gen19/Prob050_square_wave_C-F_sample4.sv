module square_wave (
    input  wire        clk,
    input  wire        rst_n,     // Active-low synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      enable;
    wire [7:0] freq_minus_one;
    wire      toggle_condition;

    assign enable = (freq != 8'd0);
    assign freq_minus_one = freq - 8'd1;
    assign toggle_condition = enable && (count == freq_minus_one);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (toggle_condition) begin
            count    <= 8'd0;
            wave_out <= ~wave_out;
        end else if (enable) begin
            count <= count + 8'd1;
        end else begin
            count <= 8'd0;         // Hold count at zero when disabled
            wave_out <= wave_out;  // Hold output steady when disabled
        end
    end

endmodule