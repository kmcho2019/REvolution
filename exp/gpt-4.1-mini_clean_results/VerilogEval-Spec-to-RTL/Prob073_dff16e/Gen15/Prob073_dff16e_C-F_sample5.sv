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
            // Create masks for each byte enable
            // If byteena bit is set, update that byte from d, else keep old q byte
            q <= ({16{byteena[1]}} & {8{1'b1}, d[15:8]}) | 
                 ({16{~byteena[1]}} & {8{1'b1}, q[15:8]}); // upper byte
            q[7:0] <= byteena[0] ? d[7:0] : q[7:0];        // lower byte
        end
    end

endmodule