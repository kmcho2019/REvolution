module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// State encoding
localparam A = 3'd0;
localparam B = 3'd1;
localparam C = 3'd2;
localparam D = 3'd3;
localparam E = 3'd4;
localparam F = 3'd5;

reg [2:0] state, next_state;

// Next state logic
always @(*) begin
    case(state)
        A: next_state = (w == 1'b0) ? B : A;
        B: next_state = (w == 1'b0) ? C : D;
        C: next_state = (w == 1'b0) ? E : D;
        D: next_state = (w == 1'b0) ? F : A;
        E: next_state = (w == 1'b0) ? E : D;
        F: next_state = (w == 1'b0) ? C : D;
        default: next_state = A;
    endcase
end

// State register update
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

// Output logic
always @(*) begin
    case(state)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule