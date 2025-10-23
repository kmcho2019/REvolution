module square_wave (
    input  wire       clk,
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;

    // Clock enable active only when freq > 1 to avoid toggling at freq=0 or freq=1
    wire clk_en = (freq > 8'd1);

    always @(posedge clk) begin
        if (!clk_en) begin
            // Hold output steady and counter at zero when freq=0 or freq=1
            wave_out <= wave_out;
            count <= 8'd0;
        end else if (count == 8'd0) begin
            // Toggle output and reload counter
            wave_out <= ~wave_out;
            count <= freq;
        end else begin
            // Decrement counter
            count <= count - 1'b1;
        end
    end

endmodule