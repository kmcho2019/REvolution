module square_wave (
    input wire clk,
    input wire rst_n,         // Active-low synchronous reset
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq == 8'd0) begin
            // Hold wave_out steady if freq = 0 (no toggling)
            count <= 8'd0;
            wave_out <= wave_out;
        end else if (count == freq) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1'b1;
        end
    end

endmodule