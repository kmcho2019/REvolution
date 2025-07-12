module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);
    // Binary encoded states
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic (Moore machine: output depends only on current state)
    always @(*) begin
        out = (state == D) ? 1'b1 : 1'b0;
    end

endmodule