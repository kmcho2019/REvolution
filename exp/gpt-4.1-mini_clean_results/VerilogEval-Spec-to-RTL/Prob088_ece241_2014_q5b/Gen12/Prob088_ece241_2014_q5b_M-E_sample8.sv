module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);
    // Define one-hot states as a 2-bit vector
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;  // reset to state A
        else
            state <= next_state;
    end

    // Next-state and output logic (Mealy FSM)
    always @(*) begin
        case (state)
            A: begin
                z = x;          // output when in A
                if (x)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                z = ~x;         // output when in B
                next_state = B; // remain in B
            end
            default: begin    // just in case, go to A
                z = 1'b0;
                next_state = A;
            end
        endcase
    end
endmodule