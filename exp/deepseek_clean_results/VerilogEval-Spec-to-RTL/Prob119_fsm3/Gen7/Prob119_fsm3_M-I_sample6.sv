module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state;  // bits represent states A,B,C,D respectively

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001;  // Reset to state A (one-hot)
        end else begin
            case (1'b1)  // Synthesis will optimize this case statement
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A -> B or A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B -> B or C
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C -> D or A
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D -> B or C
                default:   state <= 4'b0001;  // Fault recovery
            endcase
        end
    end

    // Output logic (Moore: output depends only on state)
    assign out = state[3];  // Output 1 only in state D (bit 3)

endmodule