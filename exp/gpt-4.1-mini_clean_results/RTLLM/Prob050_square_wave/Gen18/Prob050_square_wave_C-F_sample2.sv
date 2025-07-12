module square_wave (
    input  wire        clk,
    input  wire        rst_n,    // synchronous active-low reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      count_en = (freq > 8'd1);         // Enable counting only when freq > 1
    wire [7:0] freq_minus_1 = freq - 8'd1;       // Precompute freq-1 for comparator

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (count_en) begin
            if (count == freq_minus_1) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and wave_out steady when counting is disabled (freq <= 1)
            count    <= count;
            wave_out <= wave_out;
        end
    end

endmodule