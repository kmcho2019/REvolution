module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    wire update_enable = (q != d);

    always @(posedge clk) begin
        if (update_enable) begin
            q <= d;
        end
    end

endmodule