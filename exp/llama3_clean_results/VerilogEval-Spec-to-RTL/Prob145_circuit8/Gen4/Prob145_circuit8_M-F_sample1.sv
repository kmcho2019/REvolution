module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state_q;

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        if (a) begin
            state_q <= 1'b0;
            q <= 1'b0;
            p <= 1'b0;
        end else if (state_q) begin
            q <= 1'b1;
            p <= 1'b1;
        end else begin
            q <= 1'b0;
            p <= 1'b0;
        end
    end else begin
        if (a) begin
            p <= 1'b1;
            if (p) begin
                state_q <= 1'b1;
                q <= 1'b1;
            end else begin
                state_q <= 1'b0;
                q <= 1'b0;
            end
        end else begin
            p <= 1'b0;
            q <= state_q;
        end
    end
end

endmodule