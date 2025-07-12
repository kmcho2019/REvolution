module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] lut_out; // LUT output (next state and output)
reg state; // Current state

// LUT implementation as a case statement
always @(*) begin
    case ({state, j, k})
        3'b000: lut_out = 2'b00; // State OFF, j=0, k=0
        3'b001: lut_out = 2'b00; // State OFF, j=0, k=1
        3'b010: lut_out = 2'b10; // State OFF, j=1, k=0
        3'b011: lut_out = 2'b10; // State OFF, j=1, k=1
        3'b100: lut_out = 2'b10; // State ON, j=0, k=0
        3'b101: lut_out = 2'b00; // State ON, j=0, k=1
        3'b110: lut_out = 2'b10; // State ON, j=1, k=0
        3'b111: lut_out = 2'b00; // State ON, j=1, k=1
        default: lut_out = 2'b00;
    endcase
end

// State register and output assignment
always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out <= 0;
    end else begin
        state <= lut_out[1];
        out <= lut_out[0];
    end
end

endmodule