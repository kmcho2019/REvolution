module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire toggle_enable;
    wire counting_enable;

    // Counting enabled when freq != 0
    assign counting_enable = (freq != 8'd0);

    // Generate toggle_enable pulse when count reaches freq-1
    assign toggle_enable = (count == (freq - 1)) && counting_enable;

    // Counter logic: count up to freq-1, reset to 0 on toggle or freq=0
    always @(posedge clk) begin
        if (!counting_enable) begin
            count <= 8'd0;
        end else if (toggle_enable) begin
            count <= 8'd0;
        end else begin
            count <= count + 1;
        end
    end

    // wave_out toggles on toggle_enable, holds steady when freq=0
    always @(posedge clk) begin
        if (!counting_enable) begin
            wave_out <= 1'b0;
        end else if (toggle_enable) begin
            wave_out <= ~wave_out;
        end
        // else hold wave_out
    end

endmodule