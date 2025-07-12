module square_wave (
    input        clk,
    input        rst,       // Active-high synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire       ce;          // clock enable for counting and toggling
    wire       toggle_flag;

    // Enable counting and toggling only when freq != 0
    assign ce = (freq != 8'd0);

    // Instead of (count == freq - 1), check if (count + 1 == freq)
    // To avoid subtractor and reduce combinational delay.
    assign toggle_flag = ce && ((count + 8'd1) == freq);

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (toggle_flag) begin
            count    <= 8'd0;
            wave_out <= ~wave_out;
        end else if (ce) begin
            count <= count + 1'b1;
        end else begin
            count <= 8'd0;  // hold count at zero when disabled
            // wave_out implicitly holds state
        end
    end

endmodule