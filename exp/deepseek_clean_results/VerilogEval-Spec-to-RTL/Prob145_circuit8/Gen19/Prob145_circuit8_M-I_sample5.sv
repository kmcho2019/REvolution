module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// State encoding
localparam IDLE   = 2'b00;
localparam ACTIVE = 2'b01;
localparam HOLD   = 2'b10;

reg [1:0] state;
reg p_prev;
reg seen_p_high;

always @(posedge clock) begin
    case (state)
        IDLE: begin
            p <= 0;
            q <= 0;
            p_prev <= 0;
            seen_p_high <= 0;
            if (a) state <= ACTIVE;
        end
        ACTIVE: begin
            p <= a;
            p_prev <= p;
            if (p) seen_p_high <= 1;
            if (seen_p_high && p_prev) state <= HOLD;
        end
        HOLD: begin
            p <= 0;
            q <= p_prev;
            if (a && !clock) state <= IDLE;  // Reset condition
        end
        default: state <= IDLE;
    endcase
end

initial begin
    state = IDLE;
    p = 0;
    q = 0;
    p_prev = 0;
    seen_p_high = 0;
end

endmodule