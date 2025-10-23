module square_wave (
    input        clk,
    input        rst,       // Active-high synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire      enable;
    wire      toggle_flag;

    // Enable counting and toggling only when freq is non-zero
    assign enable = (freq != 8'd0);
    // Toggle when count reaches freq-1, only valid if enabled
    assign toggle_flag = enable && (count == freq - 1);

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (toggle_flag) begin
            count    <= 8'd0;
            wave_out <= ~wave_out;
        end else if (enable) begin
            count <= count + 1'b1;
        end else begin
            count <= 8'd0;       // Hold count at zero when disabled
            // wave_out holds its state implicitly by absence of assignment
        end
    end

endmodule