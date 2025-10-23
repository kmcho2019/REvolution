module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    wire counting_enabled = (freq != 8'd0);

    always @(posedge clk) begin
        if (counting_enabled) begin
            if (count == freq - 1) begin
                count <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and wave_out steady when freq=0 (no toggling)
            count <= count;
            wave_out <= wave_out;
        end
    end

endmodule