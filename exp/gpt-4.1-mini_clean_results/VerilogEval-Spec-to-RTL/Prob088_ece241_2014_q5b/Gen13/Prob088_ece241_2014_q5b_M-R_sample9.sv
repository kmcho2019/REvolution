module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state vector: [1:0] - bit 0 = A, bit 1 = B
    reg [1:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            2'b01: begin // State A
                if (x)
                    next_state = 2'b10; // to B
                else
                    next_state = 2'b01; // stay A
            end
            2'b10: begin // State B
                next_state = 2'b10; // stay B regardless of x
            end
            default: next_state = 2'b01; // default to A
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // reset to A
        else
            state <= next_state;
    end

    // Output logic (Mealy)
    // z= x when in A; z= ~x when in B
    assign z = (state[0]) ? x : ~x;

endmodule