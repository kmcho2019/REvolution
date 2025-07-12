module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding with 2-bit binary codes
localparam [1:0]
    STATE_A = 2'b00,
    STATE_B = 2'b01,
    STATE_C = 2'b10,
    STATE_D = 2'b11;

reg [1:0] state, next_state;

// Next-state combinational logic
always @(*) begin
    case (state)
        STATE_A: begin
            // Priority: r[0], then r[1], then r[2], else stay in A
            if (r[0])
                next_state = STATE_B;
            else if (r[1])
                next_state = STATE_C;
            else if (r[2])
                next_state = STATE_D;
            else
                next_state = STATE_A;
        end
        STATE_B: begin
            // Stay in B if r[0]==1, else back to A
            if (r[0])
                next_state = STATE_B;
            else
                next_state = STATE_A;
        end
        STATE_C: begin
            // Stay in C if r[1]==1, else back to A
            if (r[1])
                next_state = STATE_C;
            else
                next_state = STATE_A;
        end
        STATE_D: begin
            // Stay in D if r[2]==1, else back to A
            if (r[2])
                next_state = STATE_D;
            else
                next_state = STATE_A;
        end
        default: next_state = STATE_A; // safe default
    endcase
end

// State flip-flops with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= STATE_A;
    else
        state <= next_state;
end

// Output logic: grant signals based on current state
// g[0] for B, g[1] for C, g[2] for D
assign g = (state == STATE_B) ? 3'b001 :
           (state == STATE_C) ? 3'b010 :
           (state == STATE_D) ? 3'b100 : 3'b000;

endmodule