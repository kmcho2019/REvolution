module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// One-hot encoded state register (10 states)
reg [9:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // State 0
    end
    else if (slowena) begin
        // Circular shift with rollover
        state <= {state[8:0], state[9]};
    end
end

// Output encoding (one-hot to binary)
always @(*) begin
    case (state)
        10'b0000000001: q = 4'b0000; // 0
        10'b0000000010: q = 4'b0001; // 1
        10'b0000000100: q = 4'b0010; // 2
        10'b0000001000: q = 4'b0011; // 3
        10'b0000010000: q = 4'b0100; // 4
        10'b0000100000: q = 4'b0101; // 5
        10'b0001000000: q = 4'b0110; // 6
        10'b0010000000: q = 4'b0111; // 7
        10'b0100000000: q = 4'b1000; // 8
        10'b1000000000: q = 4'b1001; // 9
        default: q = 4'b0000;       // Should never occur
    endcase
end

endmodule