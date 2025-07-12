module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

localparam A = 0;
localparam B = 1;
localparam C = 2;
localparam D = 3;
localparam E = 4;
localparam F = 5;

reg [2:0] state;
reg [2:0] next_state;

always @(*) begin
    case (state)
        A: next_state = (w) ? B : A;
        B: next_state = (w) ? C : D;
        C: next_state = (w) ? E : D;
        D: next_state = (w) ? F : A;
        E: next_state = (w) ? E : D;
        F: next_state = (w) ? C : D;
        default: next_state = A;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

assign z = (state == E || state == F) ? 1 : 0;

endmodule