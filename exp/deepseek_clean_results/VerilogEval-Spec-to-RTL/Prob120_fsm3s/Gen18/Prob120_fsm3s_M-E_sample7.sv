module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding: A=0001, B=0010, C=0100, D=1000
    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Reset to state A
        end else begin
            case (state)
                4'b0001: state <= in ? 4'b0010 : 4'b0001;  // A: 0->A, 1->B (shift left)
                4'b0010: state <= in ? 4'b0010 : 4'b0100;  // B: 0->C (shift left), 1->B
                4'b0100: state <= in ? 4'b1000 : 4'b0001;  // C: 0->A (reset), 1->D (shift left)
                4'b1000: state <= in ? 4'b0010 : 4'b0100;  // D: 0->C (shift right), 1->B (shift right twice)
                default: state <= 4'b0001;                // Handle undefined states
            endcase
        end
    end

    // Output is high only in state D (1000)
    assign out = state[3];

endmodule