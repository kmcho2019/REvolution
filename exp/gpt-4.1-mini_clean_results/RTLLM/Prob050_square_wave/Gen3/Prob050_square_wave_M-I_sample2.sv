module square_wave (
    input        clk,
    input        rst_n,     // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire      enable;
    wire      toggle_condition;

    // Enable counting and toggling only when freq is non-zero
    assign enable = (freq != 8'd0);
    assign toggle_condition = enable && (count == freq);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (toggle_condition) begin
            count    <= 8'd0;
            wave_out <= ~wave_out;
        end else if (enable) begin
            count <= count + 1'b1;
        end else begin
            count <= 8'd0;   // Hold count at zero when disabled
            wave_out <= wave_out; // Hold output steady
        end
    end

endmodule