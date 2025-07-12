module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a; // to keep track of the previous value of a

always @(posedge clk) begin
    prev_a <= a;
    if (prev_a && a) begin // check if a is 1 for two consecutive clock cycles
        q <= 0;
    end else if (!a) begin // if a is 0, set q back to 1
        q <= 1;
    end
end

initial begin
    prev_a = 0;
    q = 1; // initial output value
end

endmodule