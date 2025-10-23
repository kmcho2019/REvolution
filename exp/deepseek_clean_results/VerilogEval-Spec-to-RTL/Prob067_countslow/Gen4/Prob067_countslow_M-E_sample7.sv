module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg [9:0] onehot_state;

// Priority encoder for onehot to binary conversion
always @(*) begin
    casez(onehot_state)
        10'b0000000001: q = 4'b0000;
        10'b0000000010: q = 4'b0001;
        10'b0000000100: q = 4'b0010;
        10'b0000001000: q = 4'b0011;
        10'b0000010000: q = 4'b0100;
        10'b0000100000: q = 4'b0101;
        10'b0001000000: q = 4'b0110;
        10'b0010000000: q = 4'b0111;
        10'b0100000000: q = 4'b1000;
        10'b1000000000: q = 4'b1001;
        default: q = 4'b0000;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        onehot_state <= 10'b0000000001;  // Reset to state 0
    end
    else if (slowena) begin
        // Circular shift - wrap around from bit 9 to bit 0
        onehot_state <= {onehot_state[8:0], onehot_state[9]};
    end
end

endmodule