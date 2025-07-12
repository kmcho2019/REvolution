module TopModule(
    input  clock,
    input  a,
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

always @(posedge clock or negedge clock) begin
    if (clock == 1'b0) begin
        if (a) begin
            q <= 1'b0;
        end
    end else if (a) begin
        q <= 1'b1;
    end
end

endmodule