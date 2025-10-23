module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register implementation (one-hot encoded states)
    // [3] = D, [2] = C, [1] = B, [0] = A
    reg [3:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001;  // Reset to state A
        end else begin
            case (1'b1)  // Synthesis will optimize this to parallel muxes
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A -> B or A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B -> B or C
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C -> D or A
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D -> B or C
                default:  state <= 4'b0001;
            endcase
        end
    end

    // Output is MSB (state D)
    assign out = state[3];

endmodule