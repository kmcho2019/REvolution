module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// State register
reg current_state;
reg next_state;

// Output based on state
assign out = current_state;

// State transitions
always @(*) begin
    case (current_state)
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

// State update and asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        current_state <= OFF;
    else
        current_state <= next_state;
end

endmodule