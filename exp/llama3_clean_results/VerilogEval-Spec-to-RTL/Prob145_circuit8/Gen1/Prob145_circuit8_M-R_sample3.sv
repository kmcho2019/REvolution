module TopModule (
    input  wire clock,
    input  wire a,
    output wire p,
    output reg  q
);

assign p = clock & a;

always @(negedge clock or posedge a) begin
    if (~clock && a) begin
        q <= 1'b1;
    end else if (clock && ~a) begin
        q <= 1'b0;
    end
end

endmodule