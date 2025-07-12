module TopModule (
    input  wire clock,
    input  wire a,
    output reg p,
    output reg q
);

reg clock_at_least_once;

initial begin
    p = 0;
    q = 0;
    clock_at_least_once = 0;
end

always @(posedge clock) begin
    if (~clock_at_least_once) begin
        clock_at_least_once = 1;
    end
    p = a;
end

always @(negedge clock) begin
    if (clock_at_least_once) begin
        q = 1;
    end
end

endmodule