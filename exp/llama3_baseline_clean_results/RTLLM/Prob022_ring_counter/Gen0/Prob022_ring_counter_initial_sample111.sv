module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize to the starting state
    end else begin
        if (out == 8'b0000_0001) begin
            out <= 8'b0000_0010; // Shift to the next bit
        end else if (out == 8'b0000_0010) begin
            out <= 8'b0000_0100; // Shift to the next bit
        end else if (out == 8'b0000_0100) begin
            out <= 8'b0000_1000; // Shift to the next bit
        end else if (out == 8'b0000_1000) begin
            out <= 8'b0001_0000; // Shift to the next bit
        end else if (out == 8'b0001_0000) begin
            out <= 8'b0010_0000; // Shift to the next bit
        end else if (out == 8'b0010_0000) begin
            out <= 8'b0100_0000; // Shift to the next bit
        end else if (out == 8'b0100_0000) begin
            out <= 8'b1000_0000; // Shift to the next bit
        end else begin
            out <= 8'b0000_0001; // Wrap around to the starting state
        end
    end
end

endmodule