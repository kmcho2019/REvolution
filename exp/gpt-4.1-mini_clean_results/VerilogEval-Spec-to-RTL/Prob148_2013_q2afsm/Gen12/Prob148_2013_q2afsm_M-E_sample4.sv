module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

// One-hot state encoding
localparam [3:0]
    A = 4'b0001,
    B = 4'b0010,
    C = 4'b0100,
    D = 4'b1000;

reg [3:0] state, next_state;

// State flip-flops with synchronous active-low reset
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
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        default: next_state = A;
    endcase
end

// Output logic: grant signals are set directly by one-hot state bits
assign g = {state[3], state[2], state[1]}; 
// state[3] = D => g[2]
// state[2] = C => g[1]
// state[1] = B => g[0]
// g[0] is granted in B (state bit 1)
// g[1] in C (state bit 2)
// g[2] in D (state bit 3)

endmodule