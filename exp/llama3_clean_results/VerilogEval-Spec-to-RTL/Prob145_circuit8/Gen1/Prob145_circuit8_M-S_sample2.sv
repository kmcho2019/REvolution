module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (!clock && a) begin // Low clock phase and a is high
        p <= 0;
        q <= 0;
    end else if (clock && a) begin // High clock phase and a is high
        p <= 1;
        if (q == 0) begin
            q <= 1'b1;
        end
    end else if (clock && !a) begin // High clock phase and a is low
        p <= 0;
    end
end

endmodule