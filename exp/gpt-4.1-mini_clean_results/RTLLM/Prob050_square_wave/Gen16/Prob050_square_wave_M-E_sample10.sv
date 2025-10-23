module square_wave (
    input  wire        clk,
    input  wire        rst_n,      // Asynchronous active-low reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      toggle_en;

    // Terminal count detection combinational logic:
    // When freq is zero, no toggling -> toggle_en = 0
    // Otherwise toggle_en asserted when count equals freq - 1
    assign toggle_en = (freq != 8'd0) && (count == freq - 1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else begin
            if (freq == 8'd0) begin
                // Freeze count and wave_out when freq is zero
                count    <= 8'd0;
                wave_out <= wave_out;
            end else begin
                if (toggle_en) begin
                    count    <= 8'd0;
                    wave_out <= ~wave_out;
                end else begin
                    count <= count + 8'd1;
                end
            end
        end
    end

endmodule