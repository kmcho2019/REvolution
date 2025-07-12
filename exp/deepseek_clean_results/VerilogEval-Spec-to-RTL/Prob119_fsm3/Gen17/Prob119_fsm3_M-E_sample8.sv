module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register states (one-hot like but with positional meaning)
    // [3]:D [2]:C [1]:B [0]:A
    reg [3:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001; // Reset to state A (LSB set)
        end else begin
            case (state)
                4'b0001: state <= in ? 4'b0010 : 4'b0001; // A → B if in=1, else stay
                4'b0010: state <= in ? 4'b0010 : 4'b0100;  // B → C if in=0, else stay
                4'b0100: state <= in ? 4'b1000 : 4'b0001;  // C → D if in=1, else → A
                4'b1000: state <= in ? 4'b0010 : 4'b0100;  // D → B if in=1, else → C
                default: state <= 4'b0001;                  // Fault recovery
            endcase
        end
    end

    // Output is high only when in state D (MSB set)
    assign out = state[3];

endmodule