module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

// Sequential logic to update pos
always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0; // Reset pos to 0 when reset is high
    end else begin
        pos <= (pos + 1) % 8; // Increment pos and wrap around after 7
    end
end

// Combinational logic to assign out based on pos
always @(*) begin
    case (pos)
        3'd0: out = 8'b0000_0001;
        3'd1: out = 8'b0000_0010;
        3'd2: out = 8'b0000_0100;
        3'd3: out = 8'b0000_1000;
        3'd4: out = 8'b0001_0000;
        3'd5: out = 8'b0010_0000;
        3'd6: out = 8'b0100_0000;
        3'd7: out = 8'b1000_0000;
        default: out = 8'b0000_0001; // Default case, should not occur
    endcase
end

endmodule