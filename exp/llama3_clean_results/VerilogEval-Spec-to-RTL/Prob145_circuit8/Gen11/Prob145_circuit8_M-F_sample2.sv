module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // 0: idle, 1: set_p, 2: set_q

always @(posedge clock) begin
    case (state)
        0: begin // idle
            if (a) begin
                state <= 1; // transition to set_p
                p <= 1;
            end else begin
                p <= 0;
                q <= 0;
            end
        end
        1: begin // set_p
            if (a) begin
                p <= 1;
                q <= 0;
            end else begin
                p <= 0;
                state <= 2; // transition to set_q
                q <= 1;
            end
        end
        2: begin // set_q
            if (a) begin
                state <= 1; // back to set_p
                p <= 1;
                q <= 1;
            end else begin
                p <= 0;
                q <= 1;
            end
        end
    endcase
end

initial begin
    state <= 0;
    p <= 0;
    q <= 0;
end

endmodule