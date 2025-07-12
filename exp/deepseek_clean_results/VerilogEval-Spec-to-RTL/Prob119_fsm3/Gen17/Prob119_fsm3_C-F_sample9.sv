module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Gray code state encoding for minimal power consumption
    parameter [1:0] A = 2'b00,  // State A
                    B = 2'b01,  // State B (differs from A by 1 bit)
                    D = 2'b11,  // State D (differs from B by 1 bit)
                    C = 2'b10;  // State C (differs from D by 1 bit)

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;  // Async reset to state A
        end else begin
            case (state)
                A: state <= in ? B : A;  // A->B when in=1, else stay
                B: state <= in ? B : C;  // B->C when in=0, else stay
                C: state <= in ? D : A;  // C->D when in=1, else A
                D: state <= in ? B : C;  // D->B when in=1, else C
            endcase
        end
    end

    // Moore output depends only on current state
    assign out = (state == D);

endmodule