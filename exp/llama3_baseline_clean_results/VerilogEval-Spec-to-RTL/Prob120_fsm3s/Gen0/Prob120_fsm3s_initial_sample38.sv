module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state; // 2-bit register to encode the four states
reg [1:0] next_state; // next state

// state encoding
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

always @(posedge clk) begin
    if (reset) begin // synchronous active high reset
        state <= A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A; // default to state A
    endcase
end

// output depends on the current state
assign out = (state == D) ? 1'b1 : 1'b0;

endmodule