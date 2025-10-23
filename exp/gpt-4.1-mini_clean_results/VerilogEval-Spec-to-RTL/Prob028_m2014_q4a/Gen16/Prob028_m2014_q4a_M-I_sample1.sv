module TopModule (
    input  wire d,
    input  wire ena,
    input  wire clk,
    output reg  q
);

    always @(posedge clk) begin
        if (ena)
            q <= d;
        // else retain q
    end

endmodule