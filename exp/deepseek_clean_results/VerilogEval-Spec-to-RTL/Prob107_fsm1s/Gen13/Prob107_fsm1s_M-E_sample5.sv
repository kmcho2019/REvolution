module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding: [1] = B, [0] = A
    reg [1:0] state;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b10;  // Reset to state B
        end else begin
            case (state)
                2'b10: state <= in ? 2'b10 : 2'b01;  // B stays on 1, moves to A on 0
                2'b01: state <= in ? 2'b01 : 2'b10;  // A stays on 1, moves to B on 0
                default: state <= 2'b10;             // Fault recovery
            endcase
        end
    end

    // Output is the B state bit
    assign out = state[1];

endmodule