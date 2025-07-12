module TopModule (
    input wire clk,
    input wire d,
    output reg q
);
    reg d_sample;

    always @(posedge clk) begin
        d_sample <= d;
        q <= d_sample;
    end
endmodule