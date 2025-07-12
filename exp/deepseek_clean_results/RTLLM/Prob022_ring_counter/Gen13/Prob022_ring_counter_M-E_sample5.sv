module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] ptr;  // 3-bit pointer (0-7)

// Pointer increment and reset logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        ptr <= 3'b000;
    end
    else begin
        ptr <= ptr + 1;  // Automatically wraps around
    end
end

// Pointer to one-hot decoder
always @(*) begin
    out = 8'b00000000;
    out[ptr] = 1'b1;
end

endmodule