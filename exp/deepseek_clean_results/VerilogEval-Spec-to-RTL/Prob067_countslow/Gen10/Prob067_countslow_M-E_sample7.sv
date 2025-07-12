module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg [9:0] state;  // One-hot state representation

// State to binary output conversion
always @(*) begin
    case (1'b1)
        state[0]: q = 4'b0000;
        state[1]: q = 4'b0001;
        state[2]: q = 4'b0010;
        state[3]: q = 4'b0011;
        state[4]: q = 4'b0100;
        state[5]: q = 4'b0101;
        state[6]: q = 4'b0110;
        state[7]: q = 4'b0111;
        state[8]: q = 4'b1000;
        state[9]: q = 4'b1001;
        default: q = 4'b0000;
    endcase
end

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // Reset to state 0
    end
    else if (slowena) begin
        // Circular shift with wrap-around
        state <= {state[8:0], state[9]};
    end
end

endmodule