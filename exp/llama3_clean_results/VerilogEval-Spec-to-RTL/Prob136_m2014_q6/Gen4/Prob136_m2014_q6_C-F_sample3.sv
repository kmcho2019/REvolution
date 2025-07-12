module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
reg [2:0] currentState;

always @(posedge clk) begin
    if (reset) begin
        currentState <= 3'b000; // A
    end else begin
        case (currentState)
            3'b000: currentState <= w ? 3'b000 : 3'b001; // A
            3'b001: currentState <= w ? 3'b011 : 3'b010; // B
            3'b010: currentState <= w ? 3'b011 : 3'b100; // C
            3'b011: currentState <= w ? 3'b000 : 3'b101; // D
            3'b100: currentState <= w ? 3'b011 : 3'b100; // E
            3'b101: currentState <= w ? 3'b011 : 3'b010; // F
            default: currentState <= 3'b000; // A
        endcase
    end
end

always @(*) begin
    case (currentState)
        3'b100, 3'b101: z = 1;
        default: z = 0;
    endcase
end

endmodule