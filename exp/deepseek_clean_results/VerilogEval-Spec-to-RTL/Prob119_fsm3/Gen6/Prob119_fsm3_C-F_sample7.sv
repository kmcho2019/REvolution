module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding with concise parameter declarations
    parameter A=0, B=1, C=2, D=3;
    reg [1:0] state;

    // State transition logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= in ? B : A;  // A -> A (in=0), A -> B (in=1)
                B: state <= in ? B : C;  // B -> C (in=0), B -> B (in=1)
                C: state <= in ? D : A;  // C -> A (in=0), C -> D (in=1)
                D: state <= in ? B : C;  // D -> C (in=0), D -> B (in=1)
            endcase
        end
    end

    // Output is 1 only in state D (Moore output)
    assign out = (state == D);

endmodule