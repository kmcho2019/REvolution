module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_state;
reg q_prev;

always @(posedge clock) begin
    q_prev <= a;
end

assign p = a & clock;
assign q = (q_prev | q_state) & ~clock;

always @(posedge clock) begin
    q_state <= a;
end

initial begin
    q_state = 0;
    q_prev = 0;
end

endmodule