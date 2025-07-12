module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

    reg [7:0] q_upper;
    reg [7:0] q_lower;

    // Byte enables for each 8-bit register
    wire write_upper = byteena[1];
    wire write_lower = byteena[0];

    always @(posedge clk) begin
        if (!resetn) begin
            q_upper <= 8'b0;
            q_lower <= 8'b0;
        end else begin
            if (write_upper)
                q_upper <= d[15:8];
            if (write_lower)
                q_lower <= d[7:0];
        end
    end

    always @(*) begin
        q = {q_upper, q_lower};
    end

endmodule