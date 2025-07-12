module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

initial begin
    state = 1'b0;
    q = 1'b0;
end

always @(posedge clk) begin
    // State transition logic
    if (a & b) begin
        state <= ~state;
    end

    // Output logic
    if (a & ~b) begin
        q <= q;  // Hold q when a=1 and b=0
    end else begin
        q <= state ? ~b : b;
    end
end

endmodule