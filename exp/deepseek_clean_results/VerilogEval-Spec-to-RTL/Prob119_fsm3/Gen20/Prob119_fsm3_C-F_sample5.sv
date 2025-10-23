module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Gray code state encoding for minimal switching power
    parameter [1:0] A = 2'b00,  // State A (output 0)
                    B = 2'b01,  // State B (output 0)
                    D = 2'b11,  // State D (output 1)
                    C = 2'b10;  // State C (output 0)

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;  // Asynchronous reset to state A
        end else begin
            case (state)
                A: state <= in ? B : A;  // A->B when in=1 (only state[0] changes)
                B: state <= in ? B : C;  // B->C when in=0 (both bits change - unavoidable)
                C: state <= in ? D : A;  // C->D when in=1 (only state[1] changes)
                D: state <= in ? B : C;  // D->B when in=1 (only state[1] changes)
                default: state <= A;     // Handle any undefined states
            endcase
        end
    end

    // Moore output depends only on current state
    assign out = (state == D);  // Output 1 only in state D

endmodule