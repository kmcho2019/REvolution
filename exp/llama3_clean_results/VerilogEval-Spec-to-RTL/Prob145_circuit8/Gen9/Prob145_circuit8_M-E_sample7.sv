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
            end
        end
        1: begin // set_p
            if (~a) begin
                state <= 0; // transition to idle
                p <= 0;
            end else begin
                state <= 2; // transition to set_q
            end
        end
        2: begin // set_q
            q <= 1;
            if (~a) begin
                state <= 0; // transition to idle
            end
        end
    endcase
end

always @(negedge clock) begin
    case (state)
        0: begin // idle
            if (a) begin
                p <= 0;
            end
        end
        1: begin // set_p
            p <= 0;
        end
        2: begin // set_q
            if (~a) begin
                q <= 0;
            end
        end
    endcase
end

endmodule