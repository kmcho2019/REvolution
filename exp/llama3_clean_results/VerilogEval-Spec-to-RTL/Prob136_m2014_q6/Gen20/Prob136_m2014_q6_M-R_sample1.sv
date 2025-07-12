module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;

always @(posedge clk) begin
    if (reset) currentState <= 3'b000; // Reset to state A
    else begin
        case (currentState)
            3'b000: currentState <= (w == 1'b0) ? 3'b001 : 3'b000; // A
            3'b001: currentState <= (w == 1'b0) ? 3'b011 : 3'b010; // B
            3'b011: currentState <= (w == 1'b0) ? 3'b110 : 3'b010; // C
            3'b010: currentState <= (w == 1'b0) ? 3'b111 : 3'b000; // D
            3'b110: currentState <= (w == 1'b0) ? 3'b110 : 3'b010; // E
            3'b111: currentState <= (w == 1'b0) ? 3'b011 : 3'b010; // F
            default: currentState <= 3'b000;
        endcase
    end
end

// Using assign for output z logic
assign z = (currentState == 3'b110) || (currentState == 3'b111);

endmodule