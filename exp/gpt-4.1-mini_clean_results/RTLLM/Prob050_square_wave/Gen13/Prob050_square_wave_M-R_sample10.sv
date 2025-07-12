module square_wave (
    input  wire        clk,
    input  wire        rst,       // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      count_en = (freq != 8'd0);
    wire      terminal_count = (count == freq - 8'd1);

    // Counter process: increment or reset count
    always @(posedge clk) begin
        if (rst) begin
            count <= 8'd0;
        end else if (count_en) begin
            if (terminal_count)
                count <= 8'd0;
            else
                count <= count + 8'd1;
        end else begin
            count <= 8'd0;
        end
    end

    // Wave output toggling process
    always @(posedge clk) begin
        if (rst) begin
            wave_out <= 1'b0;
        end else if (count_en && terminal_count) begin
            wave_out <= ~wave_out;
        end else begin
            wave_out <= wave_out;
        end
    end

endmodule