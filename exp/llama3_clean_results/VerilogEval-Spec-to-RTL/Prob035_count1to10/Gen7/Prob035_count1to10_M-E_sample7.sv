module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [9:0] state; // One-hot encoding for states 1 to 10

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b1; // Reset to state 1
    end else begin
        case (state)
            10'b1: state <= 10'b10; // Transition from state 1 to state 2
            10'b10: state <= 10'b100; // Transition from state 2 to state 3
            10'b100: state <= 10'b1000; // Transition from state 3 to state 4
            10'b1000: state <= 10'b10000; // Transition from state 4 to state 5
            10'b10000: state <= 10'b100000; // Transition from state 5 to state 6
            10'b100000: state <= 10'b1000000; // Transition from state 6 to state 7
            10'b1000000: state <= 10'b10000000; // Transition from state 7 to state 8
            10'b10000000: state <= 10'b100000000; // Transition from state 8 to state 9
            10'b100000000: state <= 10'b1; // Transition from state 9 to state 1 (wrap-around)
            default: state <= 10'b1; // Default to state 1
        endcase
    end
end

always @(*) begin
    case (state)
        10'b1: q = 4'b0001;
        10'b10: q = 4'b0010;
        10'b100: q = 4'b0011;
        10'b1000: q = 4'b0100;
        10'b10000: q = 4'b0101;
        10'b100000: q = 4'b0110;
        10'b1000000: q = 4'b0111;
        10'b10000000: q = 4'b1000;
        10'b100000000: q = 4'b1001;
        default: q = 4'b0001;
    endcase
end

endmodule