module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : bit_registers
            reg bit_q;
            always @(posedge clk) begin
                if (!resetn) begin
                    bit_q <= 1'b0;
                end else begin
                    // Check if this bit's byte is enabled
                    if ((i >= 8 && byteena[1]) || (i < 8 && byteena[0])) begin
                        bit_q <= d[i];
                    end
                end
            end
            assign q[i] = bit_q;
        end
    endgenerate
endmodule