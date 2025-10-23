module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// State codes
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

reg [2:0] currentState;
reg [2:0] nextState;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// State table
always @(*) begin
    case (currentState)
        A: nextState = (w == 1) ? B : A;
        B: nextState = (w == 1) ? C : D;
        C: nextState = (w == 1) ? E : D;
        D: nextState = (w == 1) ? F : A;
        E: nextState = (w == 1) ? E : D;
        F: nextState = (w == 1) ? C : D;
        default: nextState = A; // In case of unknown state
    endcase
end

// FSM output
always @(*) begin
    case (currentState)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0; // In case of unknown state
    endcase
end

endmodule