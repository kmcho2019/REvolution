module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// State encoding
localparam IDLE  = 2'b00;
localparam SAMPLE = 2'b01;
localparam HOLD   = 2'b10;

reg [1:0] state, next_state;
reg p_delayed;
reg a_reset_condition;

always @(posedge clock) begin
    state <= next_state;
    p_delayed <= p;  // Delay p by one cycle for q generation
end

always @(negedge clock) begin
    // Detect reset condition: a high during low phase when in HOLD state
    a_reset_condition <= (state == HOLD) && a;
end

always @(*) begin
    case (state)
        IDLE: begin
            p = 0;
            q = 0;
            next_state = (a && clock) ? SAMPLE : IDLE;
        end
        SAMPLE: begin
            p = a;
            q = p_delayed;
            next_state = (p) ? HOLD : SAMPLE;
        end
        HOLD: begin
            p = 0;
            q = 1;
            next_state = (a_reset_condition) ? IDLE : HOLD;
        end
        default: begin
            p = 0;
            q = 0;
            next_state = IDLE;
        end
    endcase
end

initial begin
    state = IDLE;
    next_state = IDLE;
    p = 0;
    q = 0;
    p_delayed = 0;
    a_reset_condition = 0;
end

endmodule