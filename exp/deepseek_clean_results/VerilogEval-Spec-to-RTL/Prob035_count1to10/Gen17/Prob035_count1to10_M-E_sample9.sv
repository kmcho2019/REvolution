module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] state;  // One-hot states for 1-10 (bits 0-9 represent 1-10)

// Binary encoder for output
always @(*) begin
    case (1'b1)
        state[0]: q = 4'b0001;
        state[1]: q = 4'b0010;
        state[2]: q = 4'b0011;
        state[3]: q = 4'b0100;
        state[4]: q = 4'b0101;
        state[5]: q = 4'b0110;
        state[6]: q = 4'b0111;
        state[7]: q = 4'b1000;
        state[8]: q = 4'b1001;
        state[9]: q = 4'b1010;
        default: q = 4'b0001;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // Reset to state 1
    end else begin
        // Circular shift left
        state <= {state[8:0], state[9]};
    end
end

endmodule