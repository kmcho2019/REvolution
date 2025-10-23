module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state, next_state;

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// State table
always @(*) begin
    case(state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? E : D;
        D: next_state = w? F : A;
        E: next_state = w? E : D;
        F: next_state = w? C : D;
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign z = (state == E || state == F)? 1'b1 : 1'b0;

endmodule