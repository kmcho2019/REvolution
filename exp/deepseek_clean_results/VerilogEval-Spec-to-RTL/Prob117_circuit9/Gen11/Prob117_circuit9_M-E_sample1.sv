module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State transition logic
always @(posedge clk) begin
    case ({a})
        1'b1: q <= 3'b100;  // Set to 4 when a is high
        1'b0: begin
            if (q == 3'b110)  // If current state is 6
                q <= 3'b000;  // Wrap around to 0
            else if (q == 3'b100 || q == 3'b101 || q == 3'b000 || q == 3'b001)
                q <= q + 1'b1;  // Increment otherwise
            else
                q <= 3'b100;  // Default to 4 if in unexpected state
        end
    endcase
end

endmodule