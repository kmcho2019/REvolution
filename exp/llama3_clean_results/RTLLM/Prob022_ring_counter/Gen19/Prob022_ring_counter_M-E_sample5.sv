module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] count; // 3-bit counter to keep track of current position

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 3'b000; // Reset counter to 0 when reset is high
        out <= 8'b0000_0001; // Initialize output to starting state
    end else begin
        count <= count + 1; // Increment counter on each clock edge
        if (count == 8) begin
            count <= 0; // Wrap counter around to 0 after reaching 7
        end
        // Use case statement to set output based on count
        case (count)
            3'b000: out <= 8'b0000_0001;
            3'b001: out <= 8'b0000_0010;
            3'b010: out <= 8'b0000_0100;
            3'b011: out <= 8'b0000_1000;
            3'b100: out <= 8'b0001_0000;
            3'b101: out <= 8'b0010_0000;
            3'b110: out <= 8'b0100_0000;
            3'b111: out <= 8'b1000_0000;
        endcase
    end
end

endmodule