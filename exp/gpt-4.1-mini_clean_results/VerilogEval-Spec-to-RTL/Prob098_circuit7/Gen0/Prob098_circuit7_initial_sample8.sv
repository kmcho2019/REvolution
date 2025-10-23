module TopModule(
    input clk,
    input a,
    output reg q
);
    reg prev_a;

    always @(posedge clk) begin
        prev_a <= a;
        if (a == 1'b0) begin
            q <= 1'b1;          // set q when a=0
        end else if (a == 1'b1 && prev_a == 1'b1) begin
            q <= 1'b0;          // reset q when a=1 two cycles in a row
        end
        // else q remains unchanged
    end
endmodule