module TopModule (
    input clk,
    input d,
    output reg q
);
    // Direct DFF implementation inside TopModule
    always @(posedge clk) begin
        q <= d;
    end
endmodule