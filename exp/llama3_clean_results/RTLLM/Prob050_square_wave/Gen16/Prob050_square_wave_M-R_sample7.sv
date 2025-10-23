module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg state = 1'b0; // 0: increment, 1: toggle

always @(posedge clk) begin
    case (state)
        1'b0: begin
            if (count == freq) begin
                state <= 1'b1;
            end else begin
                count <= count + 8'd1;
            end
        end
        1'b1: begin
            wave_out <= ~wave_out;
            count <= 8'd0;
            state <= 1'b0;
        end
    endcase
end

endmodule