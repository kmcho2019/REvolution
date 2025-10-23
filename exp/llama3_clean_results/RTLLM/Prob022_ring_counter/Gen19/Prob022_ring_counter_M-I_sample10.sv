module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0; // Reset position to 0
        out <= 8'b0000_0001; // Reset out to starting state
    end else begin
        pos <= (pos == 7) ? 0 : pos + 1; // Increment or wrap around
        case (pos)
            0: out <= 8'b0000_0001;
            1: out <= 8'b0000_0010;
            2: out <= 8'b0000_0100;
            3: out <= 8'b0000_1000;
            4: out <= 8'b0001_0000;
            5: out <= 8'b0010_0000;
            6: out <= 8'b0100_0000;
            7: out <= 8'b1000_0000;
        endcase
    end
end

endmodule