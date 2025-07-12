module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000001;
    end else begin
        case (out)
            8'b00000001: out <= 8'b00000010;
            8'b00000010: out <= 8'b00000100;
            8'b00000100: out <= 8'b00001000;
            8'b00001000: out <= 8'b00010000;
            8'b00010000: out <= 8'b00100000;
            8'b00100000: out <= 8'b01000000;
            8'b01000000: out <= 8'b10000000;
            8'b10000000: out <= 8'b00000001;
            default:     out <= 8'b00000001; // Reset to default if out is invalid
        endcase
    end
end

endmodule