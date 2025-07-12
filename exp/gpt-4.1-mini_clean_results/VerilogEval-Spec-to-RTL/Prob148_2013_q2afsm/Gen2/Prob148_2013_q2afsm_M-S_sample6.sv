module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;

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
            if (r[0])       next_state = B;       // device 0 has highest priority
            else if (r[1])  next_state = C;       // device 1 next priority
            else            next_state = A;       // device 2 requests handled by output
        end
        B: begin
            if (r[0])       next_state = B;
            else            next_state = A;
        end
        C: begin
            if (r[1])       next_state = C;
            else            next_state = A;
        end
        default: next_state = A;
    endcase
end

// Output logic: grant signals based on state and input
// State B grants device 0, C grants device 1.
// State A grants device 2 only if r[2]=1 and r[1]=0 and r[0]=0.
assign g = (state == B) ? 3'b001 :
           (state == C) ? 3'b010 :
           ((state == A) && (r == 3'b100)) ? 3'b100 :
           3'b000;

endmodule