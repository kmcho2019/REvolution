module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding (A=0001, B=0010, C=0100, D=1000)
    reg [3:0] state;

    // Output is MSB (state D)
    assign out = state[3];

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Reset to state A
        end else begin
            case (1'b1)  // Synthesis will optimize this to parallel case
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A->B or A->A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B->B or B->C
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C->D or C->A
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D->B or D->C
                default: state <= 4'b0001;
            endcase
        end
    end

endmodule