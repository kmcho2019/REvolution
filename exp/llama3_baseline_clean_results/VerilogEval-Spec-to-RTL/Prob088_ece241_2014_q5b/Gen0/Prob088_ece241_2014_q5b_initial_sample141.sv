module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case(current_state)
        2'b01: begin // State A
            if(x) next_state = 2'b10; // Transition to B if x = 1
            else next_state = 2'b01; // Stay in A if x = 0
            z = x; // Output z in state A is x
        end
        2'b10: begin // State B
            next_state = 2'b10; // Always stay in B
            z = ~x; // Output z in state B is ~x
        end
        default: begin
            next_state = 2'b01; // Default state is A
            z = 1'b0; // Safe default for z
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) current_state <= 2'b01; // Reset to state A
    else current_state <= next_state;
end

endmodule