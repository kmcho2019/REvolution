module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Create byte masks: upper byte (bits 15:8), lower byte (bits 7:0)
        // Update q by selectively assigning bytes from d or keeping old q bits
        q <= ({16{byteena[1]}} & {d[15:8], 8'b0}) | 
             ({16{byteena[0]}} & {8'b0, d[7:0]}) | 
             (~({16{byteena[1]}} | {16{byteena[0]}}) & q);
    end
end

endmodule