module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (~prev_a && a) begin
        q <= 0; // Reset q when a goes from 0 to 1
    end else if (~a) begin
        q <= 1; // Set q when a is 0
    end
end

endmodule