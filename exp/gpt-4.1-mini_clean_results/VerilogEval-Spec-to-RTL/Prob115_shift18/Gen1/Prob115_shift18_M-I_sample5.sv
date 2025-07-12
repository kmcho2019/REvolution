module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    // Internal wire to hold shifted value
    reg [63:0] shifted;

    // Extract sign bit once
    wire sign = q[63];

    always @(*) begin
        case (amount)
            2'b00: // shift left by 1
                shifted = q << 1;
            2'b01: // shift left by 8
                shifted = q << 8;
            2'b10: // arithmetic shift right by 1
                shifted = ({64{sign}} << 63) | (q >> 1);
            2'b11: // arithmetic shift right by 8
                shifted = ({64{sign}} << 56) | (q >> 8);
            default:
                shifted = q; // Should never happen
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
    end

endmodule