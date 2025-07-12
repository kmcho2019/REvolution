module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0; // Reset position to 0
        out <= 8'b0000_0001; // Initialize output to the starting state
    end else begin
        if (pos == 7) begin
            pos <= 0; // Wrap around to 0 after 7
        end else begin
            pos <= pos + 1; // Increment position
        end
        // Calculate output based on current position
        case (pos)
            3'd0: out <= 8'b0000_0001;
            3'd1: out <= 8'b0000_0010;
            3'd2: out <= 8'b0000_0100;
            3'd3: out <= 8'b0000_1000;
            3'd4: out <= 8'b0001_0000;
            3'd5: out <= 8'b0010_0000;
            3'd6: out <= 8'b0100_0000;
            3'd7: out <= 8'b1000_0000;
        endcase
    end
end

endmodule