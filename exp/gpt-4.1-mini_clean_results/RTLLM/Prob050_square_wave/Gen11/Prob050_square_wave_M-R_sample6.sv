module square_wave (
    input        clk,
    input        rst_n,     // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] freq_minus_one;
    wire toggle_condition;

    assign freq_minus_one = freq - 1'b1;
    assign toggle_condition = (freq != 8'd0) && (count == freq_minus_one);

    // Counter logic
    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 8'd0;
        end else if (toggle_condition) begin
            count <= 8'd0;
        end else if (freq != 8'd0) begin
            count <= count + 1'b1;
        end else begin
            count <= 8'd0; // Hold count when freq is zero
        end
    end

    // Output toggle logic
    always @(posedge clk) begin
        if (!rst_n) begin
            wave_out <= 1'b0;
        end else if (toggle_condition) begin
            wave_out <= ~wave_out;
        end
    end

endmodule