module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // For each byte, update if byteena bit is set; otherwise keep old value
            q[7:0]   <= byteena[0] ? d[7:0]   : q[7:0];
            q[15:8]  <= byteena[1] ? d[15:8]  : q[15:8];
        end
    end

endmodule