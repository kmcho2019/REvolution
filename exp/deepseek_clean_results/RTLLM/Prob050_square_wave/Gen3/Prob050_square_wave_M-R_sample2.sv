module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire toggle = (count == 8'd0) && (freq != 8'd0);

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            count <= 8'd0;
        end else if (toggle) begin
            count <= freq - 8'd1;
        end else begin
            count <= count - 8'd1;
        end
    end

    always @(posedge clk) begin
        if (toggle) begin
            wave_out <= ~wave_out;
        end
    end

endmodule