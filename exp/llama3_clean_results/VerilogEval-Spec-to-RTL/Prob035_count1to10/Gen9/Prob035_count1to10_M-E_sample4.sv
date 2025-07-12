module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

// One-hot encoded states for counts 1 to 10
reg [9:0] state = 10'b0000000001;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // Reset to state for count 1
    end else begin
        // Transition to the next state
        case (state)
            10'b0000000001: state <= 10'b0000000010; // 1 -> 2
            10'b0000000010: state <= 10'b0000000100; // 2 -> 3
            10'b0000000100: state <= 10'b0000001000; // 3 -> 4
            10'b0000001000: state <= 10'b0000010000; // 4 -> 5
            10'b0000010000: state <= 10'b0000100000; // 5 -> 6
            10'b0000100000: state <= 10'b0001000000; // 6 -> 7
            10'b0001000000: state <= 10'b0010000000; // 7 -> 8
            10'b0010000000: state <= 10'b0100000000; // 8 -> 9
            10'b0100000000: state <= 10'b1000000000; // 9 -> 10
            10'b1000000000: state <= 10'b0000000001; // 10 -> 1
            default: state <= 10'b0000000001; // Default to state for count 1
        endcase
    end
end

// Decode the state to produce the 4-bit count value
always @(*) begin
    case (state)
        10'b0000000001: q = 4'b0001; // Count 1
        10'b0000000010: q = 4'b0010; // Count 2
        10'b0000000100: q = 4'b0011; // Count 3
        10'b0000001000: q = 4'b0100; // Count 4
        10'b0000010000: q = 4'b0101; // Count 5
        10'b0000100000: q = 4'b0110; // Count 6
        10'b0001000000: q = 4'b0111; // Count 7
        10'b0010000000: q = 4'b1000; // Count 8
        10'b0100000000: q = 4'b1001; // Count 9
        10'b1000000000: q = 4'b1010; // Count 10
        default: q = 4'b0001; // Default to count 1
    endcase
end

endmodule