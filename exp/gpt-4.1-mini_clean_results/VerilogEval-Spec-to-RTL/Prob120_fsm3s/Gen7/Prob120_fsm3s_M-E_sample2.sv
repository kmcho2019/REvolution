module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot encoded states
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        // Default no change
        next_state = 4'b0000;
        case (state)
            A: begin
                if (in == 1'b0)
                    next_state = A;
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
            default: next_state = A; // For safety
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output directly from state D flip-flop
    assign out = state[3];

endmodule