module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // One-hot state encoding: state[1]=A, state[0]=B
    reg [1:0] state, next_state;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b10; // Reset to state A (one-hot: 10)
        else
            state <= next_state;
    end

    // Next state and output logic combined (Mealy)
    always @(*) begin
        case (state)
            2'b10: begin // State A
                z = x;
                next_state = x ? 2'b01 : 2'b10;
            end
            2'b01: begin // State B
                z = ~x;
                next_state = 2'b01; // stay in B regardless of x
            end
            default: begin
                z = 1'b0;
                next_state = 2'b10; // default to reset state A
            end
        endcase
    end

endmodule