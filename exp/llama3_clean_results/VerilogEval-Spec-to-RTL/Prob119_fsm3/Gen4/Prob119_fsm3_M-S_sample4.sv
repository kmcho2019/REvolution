module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg [1:0] state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to state A
        out <= 0;
    end else begin
        case (state)
            2'b00: state <= in? 2'b01 : 2'b00; // A to B or stay in A
            2'b01: state <= in? 2'b01 : 2'b10; // B to B or C
            2'b10: state <= in? 2'b11 : 2'b00; // C to D or A
            2'b11: state <= in? 2'b01 : 2'b10; // D to B or C
        endcase
        out <= (state == 2'b11); // Output is 1 only in state D
    end
end

endmodule