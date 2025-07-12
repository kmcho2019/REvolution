module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 1'b1;
    end else if (!a) begin
        // No action on q when a is 0 at negedge clock
        // Since we only update q when a was 1 during the previous posedge clock
    end
end

endmodule