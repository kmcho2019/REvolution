module square_wave (
    input  wire        clk,
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire [7:0] terminal_count;

    // Terminal count is freq - 1, but if freq=0, terminal_count = 0xff (255), so no toggle occurs
    assign terminal_count = (freq == 8'd0) ? 8'd255 : (freq - 8'd1);

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // Hold count and wave_out steady when freq is zero (no toggling)
            count    <= 8'd0;
            wave_out <= wave_out;
        end else begin
            if (count == terminal_count) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end
    end

endmodule