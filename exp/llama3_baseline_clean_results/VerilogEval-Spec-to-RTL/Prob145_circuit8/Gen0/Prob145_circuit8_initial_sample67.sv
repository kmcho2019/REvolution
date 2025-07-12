module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Directly assign p when clock is high
always @(posedge clock) begin
    p <= a;
end

// For q, it becomes high after p is high and remains high until explicitly changed
always @(posedge clock or negedge clock) begin
    if (!clock) begin
        if (p) begin
            q <= 1'b1;
        end
    end else if (clock && !a) begin
        q <= 1'b0;
    end
end

endmodule