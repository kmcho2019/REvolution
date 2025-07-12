module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a == 1'b1) begin
        // Set p when a is 1 and clock is high
        p <= 1'b1;
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        // Reset p when a is 1 and clock is low
        p <= 1'b0;
    end
end

always @(*) begin
    if (p == 1'b1) begin
        // Set q when p is 1
        q = 1'b1;
    end else begin
        // Reset q when p is 0
        q = 1'b0;
    end
end

endmodule