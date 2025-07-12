module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state;

localparam WAIT = 1'b0;
localparam PULSE = 1'b1;

always @(posedge clock) begin
    case (state)
        WAIT: begin
            if (a) begin
                state <= PULSE;
                p <= 1'b1;
            end else begin
                p <= 1'b0;
            end
            q <= 1'b0;
        end
        PULSE: begin
            state <= WAIT;
            p <= 1'b0;
            q <= ~a;
        end
    endcase
end

initial begin
    state = WAIT;
    p = 1'b0;
    q = 1'b0;
end

endmodule