module square_wave (
    input  wire        clk,
    input  wire        rst_n,      // Active-low asynchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      terminal_count;
    wire      count_en;

    assign count_en = (freq != 8'd0);
    assign terminal_count = (count == (freq - 8'd1)) && count_en;

    // Counter with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 8'd0;
        end else if (count_en) begin
            if (terminal_count) begin
                count <= 8'd0;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            count <= 8'd0;
        end
    end

    // Wave_out toggle logic with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave_out <= 1'b0;
        end else if (terminal_count) begin
            wave_out <= ~wave_out;
        end else begin
            wave_out <= wave_out;
        end
    end

endmodule