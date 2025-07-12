module square_wave (
    input  wire       clk,
    input  wire       rst_n,      // synchronous active-low reset
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;

    // Enable counting and toggling only if freq > 1
    wire clk_en = (freq > 8'd1);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (clk_en) begin
            if (count == (freq - 1)) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            // Hold count and wave_out steady when not enabled (freq <= 1)
            count    <= count;
            wave_out <= wave_out;
        end
    end

endmodule