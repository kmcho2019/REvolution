module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// One-hot encoding for states A and B
reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    case(current_state)
        2'b01: z = x; // State A
        2'b10: z = ~x; // State B
        default: z = 1'b0; // Invalid state, default output
    endcase
end

// Next state logic
always @(*) begin
    case(current_state)
        2'b01: begin // State A
            if(x == 1'b0) next_state = 2'b01;
            else next_state = 2'b10;
        end
        2'b10: next_state = 2'b10; // State B
        default: next_state = 2'b01; // Invalid state, default next state
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if(areset) current_state <= 2'b01; // Reset to state A
    else current_state <= next_state;
end

endmodule