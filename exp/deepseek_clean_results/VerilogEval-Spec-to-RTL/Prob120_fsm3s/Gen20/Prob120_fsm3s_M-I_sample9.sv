module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // One-hot state encoding (A=0001, B=0010, C=0100, D=1000)
    reg [3:0] state;

    // State transitions and register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Reset to state A
            out <= 1'b0;
        end
        else begin
            case (1'b1)  // Synthesis will optimize this to parallel case
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A -> B or A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B -> B or C
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C -> D or A
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D -> B or C
            endcase
            out <= state[3];  // Output is high only in state D
        end
    end

endmodule