module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state = 0; // 0: idle, 1: p_high, 2: q_high

always @(posedge clock or negedge clock) begin
    case (state)
        0: begin // idle
            if (a == 1) begin
                p <= 1;
                state <= 1; // transition to p_high
            end else begin
                p <= 0;
            end
        end
        1: begin // p_high
            if (a == 1) begin
                state <= 1; // stay in p_high
            end else begin
                p <= 0;
                state <= 2; // transition to q_high
            end
        end
        2: begin // q_high
            if (clock == 0 && a == 0) begin
                q <= 0;
                state <= 0; // transition back to idle
            end else begin
                q <= 1;
            end
        end
        default: state <= 0;
    endcase
end

always @(posedge clock) begin
    if (state == 1) begin
        q <= 1;
    end
end

endmodule