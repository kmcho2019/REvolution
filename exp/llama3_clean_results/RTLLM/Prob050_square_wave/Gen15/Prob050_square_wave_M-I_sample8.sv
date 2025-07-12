module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;
reg enable;

// Clock gating to minimize switching activity
always @(posedge clk) begin
    if (enable) begin
        if (count == freq - 1) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 8'd1;
        end
    end
end

// Default enable value (can be overridden by external logic)
assign enable = 1'b1;

endmodule