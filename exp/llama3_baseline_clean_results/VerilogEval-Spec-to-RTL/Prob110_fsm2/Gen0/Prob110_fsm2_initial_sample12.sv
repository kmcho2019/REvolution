module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] state; // Current state (0 = OFF, 1 = ON)
reg [0:0] next_state; // Next state

// State encoding
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Moore state machine output
assign out = state;

always @(*) begin
    case(state)
        OFF: next_state = (j == 1'b1) ? ON : OFF;
        ON: next_state = (k == 1'b1) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule