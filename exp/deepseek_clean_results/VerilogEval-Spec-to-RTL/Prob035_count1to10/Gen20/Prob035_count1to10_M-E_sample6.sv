module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] state;  // One-hot states: bit 0=1, bit 1=2,... bit 9=10

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // State 1
    end
    else begin
        // Circular shift with wrap-around
        if (state[9]) begin  // If at state 10
            state <= 10'b0000000001;  // Wrap to state 1
        end
        else begin
            state <= {state[8:0], 1'b0};  // Shift left
        end
    end
end

// Convert one-hot state to binary output
always @(*) begin
    case (state)
        10'b0000000001: q = 4'b0001;  // 1
        10'b0000000010: q = 4'b0010;  // 2
        10'b0000000100: q = 4'b0011;  // 3
        10'b0000001000: q = 4'b0100;  // 4
        10'b0000010000: q = 4'b0101;  // 5
        10'b0000100000: q = 4'b0110;  // 6
        10'b0001000000: q = 4'b0111;  // 7
        10'b0010000000: q = 4'b1000;  // 8
        10'b0100000000: q = 4'b1001;  // 9
        10'b1000000000: q = 4'b1010;  // 10
        default:        q = 4'b0001;  // Shouldn't occur
    endcase
end

endmodule