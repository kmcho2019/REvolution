module TopModule (
    input clk,
    input a,
    output reg q
);
    always @(posedge clk) begin
        q <= ~a;  // Invert input 'a' and store in 'q' on rising clock edge
    end
endmodule