module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  out
);

    // Define FSM states using SystemVerilog enum for clarity
    typedef enum logic [1:0] {
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3
    } state_t;

    state_t state, next_state;

    // Next state logic: purely combinational, depends on state and input
    always @(*) begin
        unique case (state)
            A: next_state = (in == 1'b1) ? B : A;
            B: next_state = (in == 1'b1) ? B : C;
            C: next_state = (in == 1'b1) ? D : A;
            D: next_state = (in == 1'b1) ? B : C;
            default: next_state = A; // Safe default/reset state
        endcase
    end

    // Output logic: Moore machine output depends only on current state
    always @(*) begin
        unique case (state)
            A: out = 1'b0;
            B: out = 1'b0;
            C: out = 1'b0;
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

    // Sequential logic: state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule