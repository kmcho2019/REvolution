module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] state; // One-hot state representation (bits 0-9 represent states 1-10)

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // State 1
    end else begin
        case (state)
            10'b0000000001: state <= 10'b0000000010; // 1->2
            10'b0000000010: state <= 10'b0000000100; // 2->3
            10'b0000000100: state <= 10'b0000001000; // 3->4
            10'b0000001000: state <= 10'b0000010000; // 4->5
            10'b0000010000: state <= 10'b0000100000; // 5->6
            10'b0000100000: state <= 10'b0001000000; // 6->7
            10'b0001000000: state <= 10'b0010000000; // 7->8
            10'b0010000000: state <= 10'b0100000000; // 8->9
            10'b0100000000: state <= 10'b1000000000; // 9->10
            10'b1000000000: state <= 10'b0000000001; // 10->1
            default: state <= 10'b0000000001; // Handle unexpected states
        endcase
    end
end

// Convert one-hot state to binary output
always @(*) begin
    case (state)
        10'b0000000001: q = 4'b0001; // 1
        10'b0000000010: q = 4'b0010; // 2
        10'b0000000100: q = 4'b0011; // 3
        10'b0000001000: q = 4'b0100; // 4
        10'b0000010000: q = 4'b0101; // 5
        10'b0000100000: q = 4'b0110; // 6
        10'b0001000000: q = 4'b0111; // 7
        10'b0010000000: q = 4'b1000; // 8
        10'b0100000000: q = 4'b1001; // 9
        10'b1000000000: q = 4'b1010; // 10
        default: q = 4'b0001;       // Default to 1
    endcase
end

endmodule