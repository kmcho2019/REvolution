module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    // Only one bit is high to indicate current state
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        // Default no change
        next_state = 4'b0000;

        case (state)
            A: begin
                if (in == 1'b0)
                    next_state = A;  // Stay in A
                else
                    next_state = B;
            end
            B: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
            end
            D: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: next_state = A;  // Safety fallback
        endcase
    end

    // Sequential logic: state register with synchronous active high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: Moore output is high only in state D
    assign out = state[3];

endmodule