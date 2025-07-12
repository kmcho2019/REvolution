module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        if (in[3]) begin
            pos = 2'b11;  // Position 3 (MSB)
        end else if (in[2]) begin
            pos = 2'b10;  // Position 2
        end else if (in[1]) begin
            pos = 2'b01;  // Position 1
        end else if (in[0]) begin
            pos = 2'b00;  // Position 0 (LSB)
        end else begin
            pos = 2'b00;  // All zeros case
        end
    end

endmodule