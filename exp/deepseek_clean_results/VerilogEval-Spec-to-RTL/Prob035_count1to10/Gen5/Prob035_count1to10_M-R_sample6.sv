module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] state;

// State transitions
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001;  // Reset to 1
    end else begin
        case (state)
            4'b0001: state <= 4'b0010;  // 1 -> 2
            4'b0010: state <= 4'b0011;  // 2 -> 3
            4'b0011: state <= 4'b0100;  // 3 -> 4
            4'b0100: state <= 4'b0101;  // 4 -> 5
            4'b0101: state <= 4'b0110;  // 5 -> 6
            4'b0110: state <= 4'b0111;  // 6 -> 7
            4'b0111: state <= 4'b1000;  // 7 -> 8
            4'b1000: state <= 4'b1001;  // 8 -> 9
            4'b1001: state <= 4'b1010;  // 9 -> 10
            4'b1010: state <= 4'b0001;  // 10 -> 1
            default: state <= 4'b0001;  // Handle unexpected states
        endcase
    end
end

assign q = state;

endmodule