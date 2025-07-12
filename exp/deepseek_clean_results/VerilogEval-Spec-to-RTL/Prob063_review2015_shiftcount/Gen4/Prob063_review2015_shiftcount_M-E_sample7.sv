module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] buffer [0:3];  // 4-entry circular buffer
reg [1:0] ptr = 0;      // Current pointer position

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift operation: write data and advance pointer
        buffer[ptr] <= data;
        ptr <= ptr + 1;
    end
    else if (count_ena) begin
        // Count operation: decrement and move pointer backward
        buffer[ptr] <= buffer[ptr] - 1'b1;
        ptr <= ptr - 1;
    end
    
    // Always update output to reflect current buffer state
    q <= {buffer[3], buffer[2], buffer[1], buffer[0]};
end

endmodule