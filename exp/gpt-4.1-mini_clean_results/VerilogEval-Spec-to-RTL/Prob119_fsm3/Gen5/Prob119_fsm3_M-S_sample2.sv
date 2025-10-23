module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

localparam A = 2'd0,
           B = 2'd1,
           C = 2'd2,
           D = 2'd3;

reg [1:0] state, next_state;

always @(*) begin
    case(state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

always @(*) begin
    out = (state == D);
end

endmodule