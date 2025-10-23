module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [9:0] state; // One-hot encoding for 10 states

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to state 0
        state <= 10'b1; // Initialize state to 0
    end else if (slowena) begin
        // Increment state
        case (state)
            10'b1: state <= 10'b10; // 0 -> 1
            10'b10: state <= 10'b100; // 1 -> 2
            10'b100: state <= 10'b1000; // 2 -> 3
            10'b1000: state <= 10'b10000; // 3 -> 4
            10'b10000: state <= 10'b100000; // 4 -> 5
            10'b100000: state <= 10'b1000000; // 5 -> 6
            10'b1000000: state <= 10'b10000000; // 6 -> 7
            10'b10000000: state <= 10'b100000000; // 7 -> 8
            10'b100000000: state <= 10'b1000000000; // 8 -> 9
            10'b1000000000: state <= 10'b1; // 9 -> 0
            default: state <= state;
        endcase
    end
end

// Decode state to generate output q
always @(state) begin
    case (state)
        10'b1: q <= 4'd0;
        10'b10: q <= 4'd1;
        10'b100: q <= 4'd2;
        10'b1000: q <= 4'd3;
        10'b10000: q <= 4'd4;
        10'b100000: q <= 4'd5;
        10'b1000000: q <= 4'd6;
        10'b10000000: q <= 4'd7;
        10'b100000000: q <= 4'd8;
        10'b1000000000: q <= 4'd9;
        default: q <= 4'd0;
    endcase
end

endmodule