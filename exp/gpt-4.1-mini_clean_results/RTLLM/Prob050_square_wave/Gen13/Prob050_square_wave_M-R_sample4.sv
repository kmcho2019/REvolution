module square_wave (
    input clk,
    input rst_n,           // synchronous active-low reset
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire toggle_condition;
    wire clk_en;

    assign clk_en = (freq > 8'd1);
    assign toggle_condition = clk_en && (count == (freq - 1));

    // Counting logic
    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 8'd0;
        end else if (clk_en) begin
            if (toggle_condition)
                count <= 8'd0;
            else
                count <= count + 1'b1;
        end else begin
            count <= 8'd0;
        end
    end

    // Wave output toggle logic
    always @(posedge clk) begin
        if (!rst_n) begin
            wave_out <= 1'b0;
        end else if (toggle_condition) begin
            wave_out <= ~wave_out;
        end
    end

endmodule