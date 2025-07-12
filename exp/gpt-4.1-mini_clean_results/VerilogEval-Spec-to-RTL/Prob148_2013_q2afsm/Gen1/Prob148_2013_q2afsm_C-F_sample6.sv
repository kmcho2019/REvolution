module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

// One-hot state encoding for 4 states (using 4 bits, only 4 states used)
localparam [3:0]
    A = 4'b0001,
    B = 4'b0010,
    C = 4'b0100,
    D = 4'b1000;

reg [3:0] state, next_state;

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case (1'b1) // one-hot style decoding
        state[A]: begin
            if (r[0])       next_state = B;       // highest priority
            else if (r[1])  next_state = C;
            else if (r[2])  next_state = D;
            else            next_state = A;
        end
        state[B]: begin
            if (r[0])       next_state = B;
            else            next_state = A;
        end
        state[C]: begin
            if (r[1])       next_state = C;
            else            next_state = A;
        end
        state[D]: begin
            if (r[2])       next_state = D;
            else            next_state = A;
        end
        default: next_state = A;
    endcase
end

// Output logic: grant signals from one-hot states
assign g = {state[D], state[C], state[B]};

endmodule