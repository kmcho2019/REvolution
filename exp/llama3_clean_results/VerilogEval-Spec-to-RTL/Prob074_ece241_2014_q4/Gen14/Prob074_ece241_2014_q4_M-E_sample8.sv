module TopModule(
    input clk,
    input x,
    output z
);

reg [2:0] state = 3'b000;

// Define the next state LUT
always @(posedge clk) begin
    case ({x, state})
        4'b0_000: state <= 3'b000;
        4'b0_001: state <= 3'b001;
        4'b0_010: state <= 3'b010;
        4'b0_011: state <= 3'b011;
        4'b0_100: state <= 3'b100;
        4'b0_101: state <= 3'b101;
        4'b0_110: state <= 3'b110;
        4'b0_111: state <= 3'b111;
        4'b1_000: state <= 3'b001;
        4'b1_001: state <= 3'b000;
        4'b1_010: state <= 3'b000;
        4'b1_011: state <= 3'b000;
        4'b1_100: state <= 3'b101;
        4'b1_101: state <= 3'b100;
        4'b1_110: state <= 3'b100;
        4'b1_111: state <= 3'b100;
        default: state <= 3'b000;
    endcase
end

// Define the output LUT
always @(*) begin
    case (state)
        3'b000: z = ~0;
        3'b001: z = ~1;
        3'b010: z = ~1;
        3'b011: z = ~1;
        3'b100: z = ~1;
        3'b101: z = ~1;
        3'b110: z = ~1;
        3'b111: z = ~1;
        default: z = ~0;
    endcase
end

endmodule