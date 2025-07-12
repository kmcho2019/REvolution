module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    reg [7:0] upper;
    reg [7:0] lower;

    always @(posedge clk) begin
        if (!resetn) begin
            upper <= 8'b0;
            lower <= 8'b0;
        end else begin
            if (byteena[1])
                upper <= d[15:8];
            if (byteena[0])
                lower <= d[7:0];
        end
    end

    always @* begin
        q = {upper, lower};
    end

endmodule