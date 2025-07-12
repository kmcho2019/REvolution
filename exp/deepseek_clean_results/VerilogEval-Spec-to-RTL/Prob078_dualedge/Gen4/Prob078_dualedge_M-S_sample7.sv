module TopModule (
    input clk,
    input d,
    output reg q
);

    always @(posedge clk, negedge clk) begin
        q <= d;
    end

endmodule