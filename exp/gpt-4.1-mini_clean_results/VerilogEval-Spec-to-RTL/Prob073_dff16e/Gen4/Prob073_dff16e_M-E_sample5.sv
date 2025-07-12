module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    reg [7:0] lower_byte, upper_byte;

    always @(posedge clk) begin
        if (!resetn) begin
            lower_byte <= 8'b0;
            upper_byte <= 8'b0;
        end else begin
            if (byteena[0])
                lower_byte <= d[7:0];
            // else hold lower_byte

            if (byteena[1])
                upper_byte <= d[15:8];
            // else hold upper_byte
        end
    end

    always @(*) begin
        q = {upper_byte, lower_byte};
    end

endmodule