module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(current_state or in) begin
    case(current_state)
        2'b00: begin // State A
            if (~in) 
                next_state = 2'b01; // Transition to state B
            else 
                next_state = 2'b00; // Stay in state A
        end
        2'b01: begin // State B
            if (~in) 
                next_state = 2'b00; // Transition to state A
            else 
                next_state = 2'b01; // Stay in state B
        end
        default: next_state = 2'b01; // Default to state B
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) 
        current_state <= 2'b01; // Asynchronously reset to state B
    else 
        current_state <= next_state;
end

always @(current_state) begin
    case(current_state)
        2'b00: out = 0; // Output 0 in state A
        2'b01: out = 1; // Output 1 in state B
        default: out = 1; // Default output
    endcase
end

endmodule