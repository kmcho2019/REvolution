module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case(current_state)
        A: next_state = (in == 0) ? A : B;
        B: next_state = (in == 0) ? C : B;
        C: next_state = (in == 0) ? A : D;
        D: next_state = (in == 0) ? C : B;
        default: next_state = A; // default to state A
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // default output
    endcase
end

endmodule