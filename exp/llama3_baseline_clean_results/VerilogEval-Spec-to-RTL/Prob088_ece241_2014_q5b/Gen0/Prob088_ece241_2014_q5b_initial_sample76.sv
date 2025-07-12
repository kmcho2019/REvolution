module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// Define initial state and reset condition
initial current_state = 2'b01; // Initialize to state A

always @(*) begin
    case(current_state)
        2'b01: begin // State A
            if(x == 0) begin
                next_state = 2'b01; // Stay in A
                z = 0;
            end else begin
                next_state = 2'b10; // Go to B
                z = 1;
            end
        end
        2'b10: begin // State B
            next_state = 2'b10; // Stay in B
            z = x ? 0 : 1; // z is the inverse of x when in state B
        end
        default: begin
            next_state = 2'b01; // If somehow in an invalid state, go to A
            z = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= 2'b01; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

endmodule