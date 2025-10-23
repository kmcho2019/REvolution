module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] current_state, next_state;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

always @(posedge clk or negedge areset) begin
    if (~areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A;
    endcase
end

always @(*) begin
    case (current_state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule