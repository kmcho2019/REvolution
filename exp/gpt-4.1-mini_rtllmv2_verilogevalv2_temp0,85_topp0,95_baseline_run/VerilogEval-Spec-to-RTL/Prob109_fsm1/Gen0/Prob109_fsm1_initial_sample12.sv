module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// State encoding
localparam A = 1'b0;
localparam B = 1'b1;

reg state, next_state;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (arest)
        state <= B;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case(state)
        B: next_state = in ? B : A;
        A: next_state = in ? A : B;
        default: next_state = B;
    endcase
end

// Output logic (Moore machine)
always @(*) begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule