module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg prev_a;
reg q_state;

initial begin
    prev_a = 0;
    q_state = 0;
end

always @(posedge clock) begin
    prev_a <= a;
    if (a == 1) begin
        q_state <= 1;
    end
    else if (prev_a == 1 && a == 0) begin
        q_state <= 0;
    end
end

assign p = (clock == 1) && (a == 1);
assign q = q_state;

endmodule