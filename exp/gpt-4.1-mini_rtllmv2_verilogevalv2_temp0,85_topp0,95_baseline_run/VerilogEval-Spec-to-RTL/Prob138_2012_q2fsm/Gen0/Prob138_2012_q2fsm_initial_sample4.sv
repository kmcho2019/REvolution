module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

// State encoding
localparam A = 3'd0;
localparam B = 3'd1;
localparam C = 3'd2;
localparam D = 3'd3;
localparam E = 3'd4;
localparam F = 3'd5;

reg [2:0] current_state, next_state;

// State flip-flops (sequential)
always @(posedge clk) begin
    if (reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A;
    endcase
end

// Output logic: z=1 in states E and F, else 0
assign z = (current_state == E) || (current_state == F);

endmodule