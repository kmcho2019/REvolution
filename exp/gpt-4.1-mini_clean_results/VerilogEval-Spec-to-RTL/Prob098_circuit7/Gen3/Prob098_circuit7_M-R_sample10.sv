module TopModule (
    input clk,
    input a,
    output reg q
);

    wire not_a;
    assign not_a = ~a;

    always @(posedge clk) begin
        q <= not_a;
    end

endmodule