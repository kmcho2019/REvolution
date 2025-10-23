module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state; // One-hot encoding for states A and B
reg [1:0] next_state;

// Define the states
parameter STATE_A = 2'b01;
parameter STATE_B = 2'b10;

// Output logic (Mealy machine)
always @(current_state, x) begin
    case(current_state)
        STATE_A: z = ~x;
        STATE_B: z = x;
        default: z = 1'b0; // Default, in case of any other state (shouldn't happen)
    endcase
end

// Next state logic
always @(current_state, x) begin
    case(current_state)
        STATE_A: begin
            if(x) next_state = STATE_B;
            else next_state = STATE_A;
        end
        STATE_B: next_state = STATE_B;
        default: next_state = STATE_A; // Default, in case of any other state (shouldn't happen)
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) current_state <= STATE_A;
    else current_state <= next_state;
end

endmodule