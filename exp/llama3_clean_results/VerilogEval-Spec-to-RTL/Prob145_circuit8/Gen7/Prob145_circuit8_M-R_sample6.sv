module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Update 'p' at the positive edge of the clock
always @(posedge clock) begin
    p <= a;
end

// Update 'q' based on 'p' and 'a' at both clock edges
always @(posedge clock or negedge clock) begin
    if (clock == 1'b1) begin
        if (a == 1'b1) begin
            q <= 1'b1;
        end
    end else begin
        if (a == 1'b1) begin
            q <= 1'b0;
        end
    end
end

endmodule