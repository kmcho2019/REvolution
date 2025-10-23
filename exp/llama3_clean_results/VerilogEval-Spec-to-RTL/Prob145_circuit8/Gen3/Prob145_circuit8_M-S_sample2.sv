module TopModule (
    input  wire clock,
    input  wire a,
    output wire p,
    output reg  q
);

assign p = clock && a;

always @(posedge clock or negedge clock) begin
    if (~clock && a) begin
        q <= 1'b1;
    end else if (clock && ~a && q) begin
        q <= 1'b0;
    end
end

initial begin
    q = 1'b0;
end

endmodule