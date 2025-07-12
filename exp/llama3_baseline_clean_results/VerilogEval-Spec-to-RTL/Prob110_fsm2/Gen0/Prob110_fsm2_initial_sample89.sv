module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 1-bit register to store the current state
reg [0:0] next_state; // 1-bit register to store the next state

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// State transition logic
always @(*) begin
    case (state)
        OFF: begin
            if (j)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON: begin
            if (k)
                next_state = OFF;
            else
                next_state = ON;
        end
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Output logic
assign out = state;

endmodule