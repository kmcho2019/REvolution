module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        p <= a;
    end

    always @(posedge clock) begin
        if (a) begin
            q <= p;
        end
    end

    // Additional logic to handle q's behavior when clock is low
    always @(negedge clock) begin
        if (!a) begin
            q <= q; // Keep previous value, but this can be optimized
        end
    end

    // Initial block for initialization, if necessary
    initial begin
        p = 0;
        q = 0;
    end

endmodule