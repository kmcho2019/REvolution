module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded state: 2 bits
// state[0] = A, state[1] = B
reg [1:0] state, next_state;

// Next state logic (combinational)
always @(*) begin
    case (state)
        2'b01: begin // State A
            if (x)
                next_state = 2'b10; // Move to B
            else
                next_state = 2'b01; // Stay in A
        end
        2'b10: begin // State B
            next_state = 2'b10; // Stay in B
        end
        default: begin
            next_state = 2'b01; // Default to A if invalid
        end
    endcase
end

// Output logic (Mealy FSM)
always @(*) begin
    case (state)
        2'b01: z = x;    // A: z = x
        2'b10: z = ~x;   // B: z = ~x
        default: z = 1'b0;
    endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // Reset to A
    else
        state <= next_state;
end

endmodule