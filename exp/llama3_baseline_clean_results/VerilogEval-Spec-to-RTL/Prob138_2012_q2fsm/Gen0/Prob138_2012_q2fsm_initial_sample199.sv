module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] nextState;

// State codes
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always @(*) begin
    case (state)
        A: nextState = w? B : A;
        B: nextState = w? C : D;
        C: nextState = w? E : D;
        D: nextState = w? F : A;
        E: nextState = w? E : D;
        F: nextState = w? C : D;
        default: nextState = A;
    endcase
end

// Output logic
assign z = (state == E) || (state == F);

endmodule