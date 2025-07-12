module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output wire z
);

    // State encoding using localparam
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state, next_state;

    // Next state logic combined inside always_ff
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case(state)
                A: next_state <= (w == 1'b0) ? B : A;
                B: next_state <= (w == 1'b0) ? C : D;
                C: next_state <= (w == 1'b0) ? E : D;
                D: next_state <= (w == 1'b0) ? F : A;
                E: next_state <= (w == 1'b0) ? E : D;
                F: next_state <= (w == 1'b0) ? C : D;
                default: next_state <= A;
            endcase
            state <= next_state;
        end
    end

    // Output logic using assign (z=1 for states E or F)
    assign z = (state == E) | (state == F);

endmodule