module square_wave (
    input clk,
    input rst_n,           // synchronous active-low reset
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    // Clock enable only when freq > 1 to avoid toggling when freq=0 or freq=1
    wire clk_en = (freq > 8'd1);

    // Use addition with carry to detect rollover without explicit comparator
    wire [8:0] count_next = count + 9'd1;
    wire toggle_condition = clk_en && (count_next[8] == 1'b1); // overflow when count+1 > freq

    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 8'd0;
            wave_out <= 1'b0;
        end else if (clk_en) begin
            if (toggle_condition) begin
                count <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and wave_out steady when clk_en=0 (freq <= 1)
            count <= 8'd0;
            wave_out <= wave_out;
        end
    end

endmodule