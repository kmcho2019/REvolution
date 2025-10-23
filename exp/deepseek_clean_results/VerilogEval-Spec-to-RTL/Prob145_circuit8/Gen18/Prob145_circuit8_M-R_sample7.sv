module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

reg reset_condition;

// Detect reset condition (a=1 during clock low)
always @(negedge clock) begin
    reset_condition <= a;
end

// Combinational logic for p
assign p = (reset_condition) ? 1'b0 : (a & ~q);

// Sequential logic for q
always @(posedge clock) begin
    if (reset_condition) begin
        q <= 1'b0;
    end else begin
        q <= p;
    end
end

initial begin
    q = 1'b0;
    reset_condition = 1'b0;
end

endmodule