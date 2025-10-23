module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

initial begin
    q = 3'd4;  // initialize to 4
end

always @(posedge clk) begin
    if (!a) begin
        q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
    // q holds its value when a=1 (implied by not assigning in this branch)
end

endmodule