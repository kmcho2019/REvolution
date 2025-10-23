module TopModule (
    input  wire clock,
    input  wire a,
    output wire p,
    output reg  q
);

always @(posedge clock) begin
    if (a) begin
        q <= 1;
    end
end

always @(negedge clock) begin
    q <= 0;
end

assign p = clock & a;

endmodule