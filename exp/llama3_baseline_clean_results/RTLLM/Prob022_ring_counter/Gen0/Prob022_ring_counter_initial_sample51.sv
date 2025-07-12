module ring_counter(
    input           clk,
    input           reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to initial state
    end else begin
        case(out)
            8'b0000_0001: out <= 8'b0000_0010;
            8'b0000_0010: out <= 8'b0000_0100;
            8'b0000_0100: out <= 8'b0000_1000;
            8'b0000_1000: out <= 8'b0001_0000;
            8'b0001_0000: out <= 8'b0010_0000;
            8'b0010_0000: out <= 8'b0100_0000;
            8'b0100_0000: out <= 8'b1000_0000;
            8'b1000_0000: out <= 8'b0000_0001; // Wrap around to initial state
            default:      out <= 8'b0000_0001; // Default to initial state
        endcase
    end
end

endmodule