module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] current_state; // 2'b00 for state A, 2'b01 for state B
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        2'b00: begin // State A
            if(x) begin
                next_state = 2'b01; // Transition to state B
            end else begin
                next_state = 2'b00; // Stay in state A
            end
        end
        2'b01: begin // State B
            next_state = 2'b01; // Stay in state B
        end
        default: next_state = 2'b00; // Default state A
    endcase
    
    // Directly drive the output z based on the current state and input x
    assign z = (current_state == 2'b00) ? x : ~x;
end

endmodule