module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);
    // Asynchronous reset with priority over clocked data capture
    always @(posedge clk or posedge ar) begin
        if (ar)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule