module TopModule (
    input clock,
    input a,
    output reg p = 1'bx,
    output reg q = 1'bx
);

reg [1:0] a_history = 2'b00;
reg initialized = 1'b0;

always @(posedge clock) begin
    if (!initialized) begin
        p <= 0;
        q <= 0;
        initialized <= 1'b1;
    end else begin
        p <= a;
        a_history <= {a_history[0], a};
        q <= a_history[1];
    end
end

always @(negedge clock) begin
    if (a && initialized) begin
        p <= 0;
        q <= 0;
        a_history <= 2'b00;
    end
end

endmodule