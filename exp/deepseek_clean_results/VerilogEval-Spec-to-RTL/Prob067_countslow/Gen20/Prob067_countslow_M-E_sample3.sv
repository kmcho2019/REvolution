module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// One-cold state encoding (only one 0 in the pattern)
reg [3:0] state;

// Next state logic (barrel shift left)
wire [3:0] next_state = slowena ? {state[2:0], state[3]} : state;

// Binary decoder for output
always @(*) begin
    case (state)
        4'b1110: q = 4'b0000;
        4'b1101: q = 4'b0001;
        4'b1011: q = 4'b0010;
        4'b0111: q = 4'b0011;
        4'b1110: q = 4'b0100;  // Rollover (same as 0)
        4'b1101: q = 4'b0101;
        4'b1011: q = 4'b0110;
        4'b0111: q = 4'b0111;
        4'b1110: q = 4'b1000;
        4'b1101: q = 4'b1001;
        default: q = 4'b0000;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b1110;  // Start at 0
    end else begin
        state <= next_state;
    end
end

endmodule