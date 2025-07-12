module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

reg [15:0] shift_reg;

always @(posedge clk) begin
    if (~resetn) begin
        shift_reg <= 16'd0;
        q <= 16'd0;
    end else begin
        if (byteena[1]) begin
            // Update upper byte
            q[15:8] <= d[15:8];
        end
        if (byteena[0]) begin
            // Update lower byte
            q[7:0] <= d[7:0];
        end
        // Shift register not needed in this implementation
        // shift_reg <= {shift_reg[14:0], d[0]};
    end
end

endmodule