module TopModule (
    input clk,
    input a,
    output q
);
    reg q_internal;

    always @(posedge clk) begin
        q_internal <= a;
    end

    assign q = ~q_internal;
endmodule