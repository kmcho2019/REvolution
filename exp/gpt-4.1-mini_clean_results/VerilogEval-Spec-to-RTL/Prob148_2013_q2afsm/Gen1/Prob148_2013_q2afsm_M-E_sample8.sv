module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);
    // One-hot state encoding: A=0001, B=0010, C=0100, D=1000
    reg [3:0] state, next_state;

    // State bits indexing for clarity
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State flip-flops with synchronous active low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic combinational
    always @(*) begin
        case (state)
            A: begin
                // Priority encoding in state A
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            B: begin
                // Stay in B if device 0 requests; else go to A
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end
            C: begin
                // Stay in C if device 1 requests; else go to A
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end
            D: begin
                // Stay in D if device 2 requests; else go to A
                if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            default: next_state = A;
        endcase
    end

    // Outputs driven by state bits B, C, D directly
    assign g = {state[3], state[2], state[1]}; // D,C,B mapped to g[2:0]

endmodule