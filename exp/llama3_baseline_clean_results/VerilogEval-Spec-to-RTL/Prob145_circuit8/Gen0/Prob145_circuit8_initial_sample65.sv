module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        p <= a;
    end

    always @(posedge clock or negedge clock) begin
        if (~clock) begin
            q <= p;
        end else if (a) begin
            q <= a;
        end
    end

endmodule