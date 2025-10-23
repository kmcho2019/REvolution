module TopModule (
    input  wire clock,
    input  wire a,
    output wire p,
    output reg  q
);

always @(negedge clock or posedge a) begin
    if (~clock) begin
        q <= 0;
    end else if (a) begin
        q <= 1;
    end
end

assign p = clock & a;

endmodule