module TopModule (
    input           clk,
    input           load,
    input           ena,
    input   [1:0]   amount,
    input   [63:0]  data,
    output reg [63:0] q
);

    wire msb = q[63];
    reg [63:0] shifted;

    always @(*) begin
        case (amount)
            2'b00: begin
                // shift left by 1 (logical)
                shifted = q << 1;
            end
            2'b01: begin
                // shift left by 8 (logical)
                shifted = q << 8;
            end
            2'b10: begin
                // shift right by 1 (arithmetic)
                // replicate MSB in vacated bit
                shifted = {msb, q[63:1]};
            end
            2'b11: begin
                // shift right by 8 (arithmetic)
                // replicate MSB in vacated bits
                shifted = {{8{msb}}, q[63:8]};
            end
            default: shifted = q; // default no shift
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        else
            q <= q;
    end

endmodule