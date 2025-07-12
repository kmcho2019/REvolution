module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot-like shift register states (circular)
    reg [3:0] state = 4'b0001;  // Initialize to state A (0001)

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Reset to state A
        end
        else begin
            case (1'b1)  // Synthesis will optimize this to parallel case
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A -> B or A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B -> B or C
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C -> D or A
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D -> B or C
            endcase
        end
    end

    // Output is high only when in state D (1000)
    assign out = state[3];

endmodule