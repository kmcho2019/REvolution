module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// One-hot encoded state register (bits 0-9 represent states 1-10)
reg [9:0] state;

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // State 1
    end
    else begin
        // Circular shift left (state 10 wraps to state 1)
        state <= {state[8:0], state[9]};
    end
end

// Priority encoder for output (convert one-hot to binary)
always @(*) begin
    casez (state)
        10'b???????1: q = 4'b0001;
        10'b??????10: q = 4'b0010;
        10'b?????100: q = 4'b0011;
        10'b????1000: q = 4'b0100;
        10'b???10000: q = 4'b0101;
        10'b??100000: q = 4'b0110;
        10'b?1000000: q = 4'b0111;
        10'b10000000: q = 4'b1000;
        10'b100000000: q = 4'b1001;
        10'b1000000000: q = 4'b1010;
        default: q = 4'b0001;  // Should never occur
    endcase
end

endmodule