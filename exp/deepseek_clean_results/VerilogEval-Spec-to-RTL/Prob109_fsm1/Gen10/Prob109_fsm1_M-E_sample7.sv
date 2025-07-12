module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register implementation (1-hot like)
    // [1] = B state, [0] = A state
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b10; // Reset to state B
        end else begin
            case (state)
                2'b10: state <= in ? 2'b10 : 2'b01; // B -> B if 1, B -> A if 0
                2'b01: state <= in ? 2'b01 : 2'b10; // A -> A if 1, A -> B if 0
                default: state <= 2'b10; // Safety
            endcase
        end
    end

    // Output is directly the B state bit
    assign out = state[1];

endmodule