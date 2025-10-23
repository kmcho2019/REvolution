module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 4-bit shift register (one-hot encoded states)
    reg [3:0] state_shift = 4'b0001;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_shift <= 4'b0001;  // Reset to state A
        end else begin
            case (state_shift)
                4'b0001: state_shift <= in ? 4'b0010 : 4'b0001;  // A -> B or A
                4'b0010: state_shift <= in ? 4'b0010 : 4'b0100;  // B -> B or C
                4'b0100: state_shift <= in ? 4'b1000 : 4'b0001;  // C -> D or A
                4'b1000: state_shift <= in ? 4'b0010 : 4'b0100;  // D -> B or C
                default: state_shift <= 4'b0001;                 // Fault recovery
            endcase
        end
    end

    // Output is directly the D state bit
    assign out = state_shift[3];

endmodule