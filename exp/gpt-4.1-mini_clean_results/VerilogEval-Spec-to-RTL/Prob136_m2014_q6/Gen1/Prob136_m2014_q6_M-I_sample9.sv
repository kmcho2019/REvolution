module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    // State encoding as localparams for synthesis efficiency
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state, next_state;

    // Next state and output logic combined
    always @(*) begin
        case(state)
            A: next_state = (w == 1'b0) ? B : A;
            B: next_state = (w == 1'b0) ? C : D;
            C: next_state = (w == 1'b0) ? E : D;
            D: next_state = (w == 1'b0) ? F : A;
            E: next_state = (w == 1'b0) ? E : D;
            F: next_state = (w == 1'b0) ? C : D;
            default: next_state = A;
        endcase
        // Output z is 1 when state is E or F (MSB bit set)
        z = next_state[2];
    end

    // State register with enable to reduce toggling
    wire state_en = (next_state != state);
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else if (state_en)
            state <= next_state;
    end

endmodule