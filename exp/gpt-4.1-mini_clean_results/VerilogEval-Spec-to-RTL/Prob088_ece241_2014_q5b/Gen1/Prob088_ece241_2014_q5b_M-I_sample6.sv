module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);
    // Binary encoded states: 1'b0 = A, 1'b1 = B
    reg state;

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to state A
        end else begin
            case (state)
                1'b0: state <= x ? 1'b1 : 1'b0;  // A: go to B if x=1
                1'b1: state <= 1'b1;             // B: stay in B
                default: state <= 1'b0;          // Safety default
            endcase
        end
    end

    // Mealy output logic (combinational)
    always @(*) begin
        case (state)
            1'b0: z = x ? 1'b1 : 1'b0;   // In A, z = x
            1'b1: z = x ? 1'b0 : 1'b1;   // In B, z = ~x
            default: z = 1'b0;
        endcase
    end
endmodule