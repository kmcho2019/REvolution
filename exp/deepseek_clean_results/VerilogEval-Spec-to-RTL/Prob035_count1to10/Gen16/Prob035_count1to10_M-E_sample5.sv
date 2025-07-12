module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] state;  // One-hot states for 1-10 (bits 0-9 represent 1-10)

// Next state logic
wire [9:0] next_state = reset ? 10'b0000000001 :  // Reset to state 1
                       (state == 10'b1000000000) ? 10'b0000000001 :  // Wrap from 10 to 1
                       {state[8:0], 1'b0};  // Normal shift left

// Output encoding (priority encoder)
always @(*) begin
    casez(state)
        10'b0000000001: q = 4'b0001;
        10'b0000000010: q = 4'b0010;
        10'b0000000100: q = 4'b0011;
        10'b0000001000: q = 4'b0100;
        10'b0000010000: q = 4'b0101;
        10'b0000100000: q = 4'b0110;
        10'b0001000000: q = 4'b0111;
        10'b0010000000: q = 4'b1000;
        10'b0100000000: q = 4'b1001;
        10'b1000000000: q = 4'b1010;
        default: q = 4'b0001;  // Should never occur
    endcase
end

// Sequential state update
always @(posedge clk) begin
    state <= next_state;
end

endmodule