module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// State register
reg [1:0] state, next_state;

// Output logic
always @(*) begin
    case(state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// State transition logic
always @(*) begin
    case(state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A;
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule