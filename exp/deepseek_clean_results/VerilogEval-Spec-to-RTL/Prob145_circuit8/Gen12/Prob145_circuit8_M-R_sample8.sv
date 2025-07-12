module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_clock;

always @(posedge clock or negedge clock) begin
    prev_clock <= clock;
end

always @(*) begin
    if (clock && !prev_clock) begin // rising edge
        p = a;
    end
    else if (!clock && prev_clock) begin // falling edge
        if (!a) begin
            p = 1'b0;
            q = 1'b0;
        end else begin
            q = p;
        end
    end
end

endmodule