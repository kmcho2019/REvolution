module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

always @(*) begin
    case (state)
        3'b000: // A
            next_state = w ? 3'b000 : 3'b001;
        3'b001: // B
            next_state = w ? 3'b011 : 3'b010;
        3'b010: // C
            next_state = w ? 3'b011 : 3'b100;
        3'b011: // D
            next_state = w ? 3'b000 : 3'b111;
        3'b100: // E
            next_state = w ? 3'b011 : 3'b100;
        3'b101: // not used
            next_state = 3'b000;
        3'b110: // F
            next_state = w ? 3'b011 : 3'b010;
        3'b111: // not used
            next_state = 3'b000;
        default:
            next_state = 3'b000;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        3'b000: z = 1'b0; // A
        3'b001: z = 1'b0; // B
        3'b010: z = 1'b0; // C
        3'b011: z = 1'b0; // D
        3'b100: z = 1'b1; // E
        3'b101: z = 1'b0; // not used
        3'b110: z = 1'b1; // F
        3'b111: z = 1'b0; // not used
        default:
            z = 1'b0;
    endcase
end

endmodule