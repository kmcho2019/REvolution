module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Current state
reg [0:0] next_state; // Next state

// Define states
parameter OFF = 1'b0;
parameter ON = 1'b1;

always @(*) begin
    case(state)
        OFF: begin
            if (j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON: begin
            if (k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1)
        state <= OFF;
    else
        state <= next_state;
end

assign out = state;

endmodule