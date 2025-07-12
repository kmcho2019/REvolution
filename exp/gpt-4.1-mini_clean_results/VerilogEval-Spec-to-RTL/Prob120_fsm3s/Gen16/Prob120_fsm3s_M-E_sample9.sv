module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic using combinational always block
    always @(*) begin
        // Default to zero to avoid latches
        next_state = 4'b0000;

        case (1'b1)  // Priority encoder style to identify current state
            state[0]: begin // State A
                next_state = (in == 1'b0) ? A : B;
            end
            state[1]: begin // State B
                next_state = (in == 1'b0) ? C : B;
            end
            state[2]: begin // State C
                next_state = (in == 1'b0) ? A : D;
            end
            state[3]: begin // State D
                next_state = (in == 1'b0) ? C : B;
            end
            default: begin
                next_state = A; // Recover to default on invalid state
            end
        endcase
    end

    // Sequential logic: state register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A; // Reset to state A (0001)
        end else begin
            state <= next_state;
        end
    end

    // Moore output: output is 1 only when in state D
    assign out = state[3];

endmodule