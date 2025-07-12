module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State encoding
localparam [1:0]
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11;

reg [1:0] state, next_state;

// State flip-flops with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next-state logic
always @(*) begin
    case(state)
        A: begin
            // Priority: r0 > r1 > r2
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
            // Stay in B if r0=1, else back to A
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            // Stay in C if r1=1, else back to A
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            // Stay in D if r2=1, else back to A
            if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        default: next_state = A;
    endcase
end

// Output logic (grant signals)
assign g = (state == B) ? 3'b001 :
           (state == C) ? 3'b010 :
           (state == D) ? 3'b100 :
           3'b000;

endmodule