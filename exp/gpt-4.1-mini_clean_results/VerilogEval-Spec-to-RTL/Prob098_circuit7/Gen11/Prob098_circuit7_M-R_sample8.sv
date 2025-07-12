module TopModule (
    input clk,
    input a,
    output reg q
);

    always @(posedge clk) begin
        q <= ~a; // Invert input 'a' at the clock edge
    end

endmodule