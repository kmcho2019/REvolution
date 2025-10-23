module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  [15:0]  q
);

    reg [15:0] q_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            q_reg <= 16'b0;
        end else begin
            // Update each byte conditionally
            q_reg <= {
                byteena[1] ? d[15:8] : q_reg[15:8],
                byteena[0] ? d[7:0]   : q_reg[7:0]
            };
        end
    end

    assign q = q_reg;

endmodule