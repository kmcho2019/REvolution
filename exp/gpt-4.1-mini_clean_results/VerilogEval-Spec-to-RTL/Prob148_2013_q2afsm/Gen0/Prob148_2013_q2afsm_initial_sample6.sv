module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State encoding
localparam A = 2'd0,
           B = 2'd1,
           C = 2'd2,
           D = 2'd3;

reg [1:0] state, next_state;

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case (state)
        A: begin
            // Priority: device 0 > device 1 > device 2
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
            // Stay in B if r0 still asserted, else back to A
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            // Stay in C if r1 still asserted, else back to A
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            // Stay in D if r2 still asserted, else back to A
            if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        default: next_state = A;
    endcase
end

// Output logic: g[i] is 1 only for the granted device in states B, C, D
assign g = (state == B) ? 3'b001 :
           (state == C) ? 3'b010 :
           (state == D) ? 3'b100 :
           3'b000;

endmodule