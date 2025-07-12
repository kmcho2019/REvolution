module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

parameter A = 0;
parameter B = 1;
parameter C = 2;
parameter D = 3;
parameter E = 4;
parameter F = 5;

reg [2:0] current_state;
reg [2:0] next_state;

// State table
always @(*) begin
    case(current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// FSM output
always @(*) begin
    case(current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = w;
        F: z = w;
        default: z = 0;
    endcase
end

endmodule