module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state; // state register
reg [2:0] next_state; // next state register

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// State table
always @(posedge clk)
begin
    if (reset)
        next_state <= A;
    else
    begin
        case (state)
            A: next_state <= (w) ? B : A;
            B: next_state <= (w) ? C : D;
            C: next_state <= (w) ? E : D;
            D: next_state <= (w) ? F : A;
            E: next_state <= (w) ? E : D;
            F: next_state <= (w) ? C : D;
            default: next_state <= A;
        endcase
    end
end

// State flip-flops
always @(posedge clk)
begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

// Output z
always @(state)
begin
    case (state)
        A: z <= 0;
        B: z <= 0;
        C: z <= 0;
        D: z <= 0;
        E: z <= 1;
        F: z <= 1;
        default: z <= 0;
    endcase
end

endmodule