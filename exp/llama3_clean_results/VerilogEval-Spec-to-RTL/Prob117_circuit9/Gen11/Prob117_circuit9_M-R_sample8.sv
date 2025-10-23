module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize 'q' to '4' at the start
initial q = 3'b100;

// Sequential logic to update 'q' at each positive clock edge
always @(posedge clk) begin
    if (a) begin
        // Reset 'q' to 4 when 'a' is high
        q <= 3'b100;
    end else begin
        // Determine the next state of 'q' based on its current value
        case (q)
            3'b110: q <= 3'b000; // Wrap around to 0 when 'q' reaches 6
            default: q <= q + 1'b1; // Increment 'q' otherwise
        endcase
    end
end

endmodule