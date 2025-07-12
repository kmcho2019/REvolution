module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Enumerating states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Current state and next state
reg [2:0] state;
reg [2:0] next_state;

// Output 'z'
assign z = (state == E || state == F) ? 1'b1 : 1'b0;

// State transitions
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case(state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

endmodule