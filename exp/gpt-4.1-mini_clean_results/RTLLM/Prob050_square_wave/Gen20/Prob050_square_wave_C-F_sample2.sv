module square_wave (
    input wire clk,
    input wire rst_n,           // Active-low synchronous reset
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire counting_enabled = (freq > 8'd1);

    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 8'd0;
            wave_out <= 1'b0;
        end else if (counting_enabled) begin
            if (count == (freq - 1)) begin
                count <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and wave_out steady when counting not enabled to reduce switching
            count <= count;
            wave_out <= wave_out;
        end
    end

endmodule