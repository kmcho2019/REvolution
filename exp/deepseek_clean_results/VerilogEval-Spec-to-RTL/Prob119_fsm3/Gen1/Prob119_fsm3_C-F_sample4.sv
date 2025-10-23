module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states using Gray encoding for reduced switching power
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b11;
    parameter D = 2'b10;

    // State register
    reg [1:0] state;

    // Next state logic with Gray-coded transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= in ? B : A;  // A->B changes only LSB
                B: state <= in ? B : C;  // B->C changes only MSB
                C: state <= in ? D : A;  // C->A changes both bits (minimum for this transition)
                D: state <= in ? B : C;  // D->B changes both bits, but D->C changes only LSB
                default: state <= A;      // Robustness for undefined states
            endcase
        end
    end

    // Output logic (Moore: output depends only on state)
    assign out = (state == D);

    // Note: In a real implementation, clock gating could be added for state A when in=0
    // to further reduce power during idle periods

endmodule