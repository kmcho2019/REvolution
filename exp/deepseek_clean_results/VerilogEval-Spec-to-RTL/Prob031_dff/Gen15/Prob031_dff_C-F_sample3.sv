`default_nettype none

module TopModule(
    input wire clk,
    input wire d,
    output reg q
);

    always @(posedge clk) begin
        q <= d;
    end

endmodule

`default_nettype wire