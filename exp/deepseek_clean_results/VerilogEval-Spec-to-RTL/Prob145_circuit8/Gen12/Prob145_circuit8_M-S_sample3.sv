module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [2:0] p_history;

always @(posedge clock) begin
    p <= a;
    p_history <= {p_history[1:0], a};
    
    if (p_history == 3'b111) begin
        q <= 1'b1;
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 1'b0;
    end
end

endmodule