module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Internal register to hold the counting sequence
reg [3:0] count_sequence [0:9];
integer i;

initial begin
    // Initialize the counting sequence 1-10
    count_sequence[0] = 4'b0001;  // 1
    count_sequence[1] = 4'b0010;  // 2
    count_sequence[2] = 4'b0011;  // 3
    count_sequence[3] = 4'b0100;  // 4
    count_sequence[4] = 4'b0101;  // 5
    count_sequence[5] = 4'b0110;  // 6
    count_sequence[6] = 4'b0111;  // 7
    count_sequence[7] = 4'b1000;  // 8
    count_sequence[8] = 4'b1001;  // 9
    count_sequence[9] = 4'b1010;  // 10
end

// Pointer to track current position in sequence
reg [3:0] ptr;

always @(posedge clk) begin
    if (reset) begin
        ptr <= 4'b0;            // Reset pointer to 0
        q <= count_sequence[0]; // Load first value (1)
    end
    else begin
        if (ptr == 4'b1001)    // If at last position
            ptr <= 4'b0;        // Wrap around
        else
            ptr <= ptr + 1;    // Increment pointer
        
        q <= count_sequence[ptr]; // Output current value
    end
end

endmodule