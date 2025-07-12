module square_wave (
    input  wire       clk,
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;
    wire [7:0] toggle_limit;
    wire       enable_toggle;

    // Calculate toggle_limit = freq/2, minimum 1 when freq > 1
    // For freq=0 or 1, disable toggling to keep wave_out steady
    assign enable_toggle = (freq > 8'd1);
    assign toggle_limit = (freq >> 1) != 0 ? (freq >> 1) : 8'd1;

    always @(posedge clk) begin
        if (!enable_toggle) begin
            // Hold wave_out and count steady when freq <= 1
            wave_out <= wave_out;
            count <= 8'd0;
        end else begin
            if (count == toggle_limit - 1) begin
                count <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule