module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;  // p captures a on positive clock edge
end

always @(negedge clock) begin
    q <= p;   // q captures p on negative clock edge
end

// Asynchronous reset when clock is low and a is high
always @(a or clock) begin
    if (!clock && a) begin
        p <= 0;
        q <= 0;
    end
end

endmodule