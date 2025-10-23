module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding (6 bits)
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic combinational block
    always @(*) begin
        next_state = 6'b0;
        case (1'b1)
            state[A]: next_state = (w == 1'b0) ? B : A;
            state[B]: next_state = (w == 1'b0) ? C : D;
            state[C]: next_state = (w == 1'b0) ? E : D;
            state[D]: next_state = (w == 1'b0) ? F : A;
            state[E]: next_state = (w == 1'b0) ? E : D;
            state[F]: next_state = (w == 1'b0) ? C : D;
            default:  next_state = A; // safe default to state A
        endcase
    end

    // State register update on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Registered output logic: z=1 for states E or F
    always @(posedge clk) begin
        z <= (state[E] | state[F]);
    end

endmodule