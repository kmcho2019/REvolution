module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        if (a) begin
            q <= 1;
        end else begin
            q <= 0;
        end
    end else begin
        if (a) begin
            p <= 1;
        end else begin
            p <= 0;
        end
    end
end

always @(posedge clock) begin
    if (a) begin
        p <= 1;
    end else begin
        p <= 0;
    end
end

always @(negedge clock) begin
    if (~a) begin
        q <= 0;
    end else begin
        q <= 1;
    end
end

endmodule