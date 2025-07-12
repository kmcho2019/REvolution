module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        // Clear outputs when clock is low
        p <= 0;
        q <= 0;
    end else begin
        // On positive clock edge
        p <= a;
        q <= p;
    end
end

endmodule