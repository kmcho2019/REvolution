module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    reg [3:0] state;

    // State transitions with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (1'b1) // Synthesis will optimize this to parallel logic
                state[0]: state <= in ? B : A;       // State A transitions
                state[1]: state <= in ? B : C;       // State B transitions
                state[2]: state <= in ? D : A;       // State C transitions
                state[3]: state <= in ? B : C;       // State D transitions
                default:  state <= A;                // Safety catch
            endcase
        end
    end

    // Output logic (Moore)
    assign out = state[3]; // Output is 1 only in state D

endmodule