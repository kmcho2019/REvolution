`default_nettype none

module TopModule(
    input wire clk,
    input wire d,
    output reg q,
    input wire en // Added enable signal for power optimization
);

    always @(posedge clk) begin
        if (en) begin
            q <= d;
        end
    end

endmodule

`default_nettype wire