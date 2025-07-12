module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [0:0] current_state;  // One-hot encoding for states A and B
assign current_state[0] = 1'b1? current_state : ~current_state; // unused bit
reg [0:0] next_state;

// Define the initial state as A (1'b1)
initial current_state = 1'b1;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= 1'b1;  // Reset into state A
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and output 'z'
always @(*) begin
    case(current_state)
        1'b1: begin  // State A
            if(x) begin
                next_state = 1'b0;  // Next state is B
                z = 1'b1;  // Output 'z' is 1
            end else begin
                next_state = 1'b1;  // Next state is A
                z = 1'b0;  // Output 'z' is 0
            end
        end
        1'b0: begin  // State B
            next_state = 1'b0;  // Next state is always B
            z = ~x;  // Output 'z' is the inverse of 'x'
        end
        default: begin
            next_state = 1'b1;  // Default next state is A
            z = 1'b0;  // Default output 'z' is 0
        end
    endcase
end

endmodule