module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_type;

state_type state, next_state;

always @(posedge clk) begin
    if (~resetn) state <= A;
    else state <= next_state;
end

always @(*) begin
    case (state)
        A: begin
            if (r[0]) next_state = B;
            else if (r[1]) next_state = C;
            else if (r[2]) next_state = D;
            else next_state = A;
        end
        B: if (r[0]) next_state = B;
           else next_state = A;
        C: if (r[1]) next_state = C;
           else next_state = A;
        D: if (r[2]) next_state = D;
           else next_state = A;
        default: next_state = A;
    endcase
end

always @(*) begin
    case (state)
        A: g = 3'b000;
        B: g = 3'b100;
        C: g = 3'b010;
        D: g = 3'b001;
        default: g = 3'b000;
    endcase
end

endmodule