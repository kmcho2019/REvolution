module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);
    localparam RESET_VAL = 1'b0;

    always @(posedge clk) begin
        if (r)
            q <= RESET_VAL;
        else
            q <= d;
    end
endmodule