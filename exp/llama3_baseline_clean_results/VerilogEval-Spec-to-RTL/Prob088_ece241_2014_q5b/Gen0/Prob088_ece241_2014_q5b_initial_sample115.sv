module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define the one-hot encoding states
localparam [1:0] STATE_A = 2'b01;
localparam [1:0] STATE_B = 2'b10;

reg [1:0] current_state;
reg [1:0] next_state;

// Output logic based on the current state and input
always @(current_state or x) begin
    case (current_state)
        STATE_A: z = x;
        STATE_B: z = ~x;
        default: z = 1'bx; // Default to unknown for invalid states
    endcase
end

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state
always @(current_state or x) begin
    case (current_state)
        STATE_A: begin
            if (~x) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
        end
        STATE_B: begin
            next_state = STATE_B; // Stay in B regardless of x
        end
        default: next_state = STATE_A; // Default to state A for invalid states
    endcase
end

endmodule