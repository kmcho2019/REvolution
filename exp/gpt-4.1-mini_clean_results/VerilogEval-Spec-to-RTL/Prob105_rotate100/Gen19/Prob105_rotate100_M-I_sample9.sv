module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

reg [99:0] next_value;
wire       clk_en;

// Clock enable asserted when load is high or ena indicates rotate left or right (01 or 10)
assign clk_en = load | (ena == 2'b01) | (ena == 2'b10);

always @(*) begin
    case (1'b1)
        load: begin
            // Load data directly
            next_value = data;
        end
        (ena == 2'b10): begin
            // Rotate left: MSB gets LSB, bits shift left by 1
            next_value = {q[98:0], q[99]};
        end
        (ena == 2'b01): begin
            // Rotate right: LSB gets MSB, bits shift right by 1
            next_value = {q[0], q[99:1]};
        end
        default: begin
            // No change
            next_value = q;
        end
    endcase
end

always @(posedge clk) begin
    if (clk_en)
        q <= next_value;
end

endmodule