module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] freq_minus_one = (freq == 0) ? 0 : freq - 1;

    initial begin
        count = 8'd0;
        wave_out = 1'b0;
    end

    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 0;
            wave_out <= wave_out; // hold state
        end else if (count == freq_minus_one) begin
            count <= 0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1;
        end
    end

endmodule