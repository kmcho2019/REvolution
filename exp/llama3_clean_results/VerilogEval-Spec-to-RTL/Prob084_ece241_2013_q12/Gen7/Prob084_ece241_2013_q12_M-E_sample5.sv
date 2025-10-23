module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] buffer;

// Circular buffer implementation
always @(posedge clk) begin
    if (enable) begin
        buffer <= {buffer[6:0], S};
    end
end

// Output logic
always @(*) begin
    case ({A, B, C})
        3'b000: Z = buffer[0];
        3'b001: Z = buffer[1];
        3'b010: Z = buffer[2];
        3'b011: Z = buffer[3];
        3'b100: Z = buffer[4];
        3'b101: Z = buffer[5];
        3'b110: Z = buffer[6];
        3'b111: Z = buffer[7];
        default: Z = 1'bx;
    endcase
end

endmodule