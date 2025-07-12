module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 4-bit shift register where each bit represents a state (A,B,C,D)
    reg [3:0] state = 4'b0001;  // Initialize to state A (one-hot)

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001;  // Reset to state A
        end else begin
            case (1'b1)  // Synthesis will optimize this to parallel load
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A -> B or A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B -> B or C
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C -> D or A
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D -> B or C
                default:  state <= 4'b0001;
            endcase
        end
    end

    // Output is simply the D state bit
    assign out = state[3];

endmodule