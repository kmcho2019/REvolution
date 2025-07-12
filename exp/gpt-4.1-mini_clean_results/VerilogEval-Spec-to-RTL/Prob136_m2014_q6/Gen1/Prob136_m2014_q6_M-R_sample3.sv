module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding as localparams
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] current_state;

    // Combinational next state signal
    reg [2:0] next_state;

    // Compute next_state combinationally using always_comb style
    always @(*) begin
        case (current_state)
            A: next_state = (w == 1'b0) ? B : A;
            B: next_state = (w == 1'b0) ? C : D;
            C: next_state = (w == 1'b0) ? E : D;
            D: next_state = (w == 1'b0) ? F : A;
            E: next_state = (w == 1'b0) ? E : D;
            F: next_state = (w == 1'b0) ? C : D;
            default: next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output combinationally assigned based on current_state
    assign z = (current_state == E) || (current_state == F);

endmodule