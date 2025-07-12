module TopModule (
    input clk,
    input a,
    output reg q
);
    always @(posedge clk) begin
        q <= ~a;  // store inverted 'a' directly at clock edge
    end
endmodule