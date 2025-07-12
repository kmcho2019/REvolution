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

// State flip-flops with synchronous active-high reset and registered output
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        z <= 1'b0;
    end else begin
        state <= next_state;
        z <= (next_state == E);
    end
end

// Next state logic
always @(*) begin
    case(state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A; // safe default
    endcase
end

endmodule