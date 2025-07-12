module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] freq_minus_one = freq - 8'd1;
    wire       toggle_condition = (count == freq_minus_one) && (freq != 8'd0);

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            count <= 8'd0;
            wave_out <= 1'b0;
        end else if (toggle_condition) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1'b1;
        end
    end

endmodule