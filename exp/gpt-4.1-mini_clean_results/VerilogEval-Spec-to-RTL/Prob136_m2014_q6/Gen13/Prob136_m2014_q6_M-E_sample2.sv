module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoding of states (6 states)
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state combinational logic using one-hot encoding
    always @(*) begin
        next_state = 6'b000000; // default to none active (should never happen)
        case (1'b1)
            state[0]: // A active
                next_state = (w == 1'b0) ? B : A;
            state[1]: // B active
                next_state = (w == 1'b0) ? C : D;
            state[2]: // C active
                next_state = (w == 1'b0) ? E : D;
            state[3]: // D active
                next_state = (w == 1'b0) ? F : A;
            state[4]: // E active
                next_state = (w == 1'b0) ? E : D;
            state[5]: // F active
                next_state = (w == 1'b0) ? C : D;
            default:
                next_state = A; // fallback
        endcase
    end

    // State flip-flops update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output combinational logic (1 if in E or F states)
    assign z = state[4] | state[5];

endmodule