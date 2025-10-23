module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// State encoding
localparam STATE_IDLE = 2'b00;
localparam STATE_P    = 2'b01;
localparam STATE_Q    = 2'b10;

reg [1:0] state;
reg a_sampled;

always @(posedge clock) begin
    case (state)
        STATE_IDLE: begin
            p <= a;
            if (a) begin
                state <= STATE_P;
            end
        end
        STATE_P: begin
            q <= 1;
            state <= STATE_Q;
        end
        STATE_Q: begin
            if (a_sampled) begin
                p <= 0;
                q <= 0;
                state <= STATE_IDLE;
            end
        end
    endcase
end

// Sample 'a' during clock low for reset condition
always @(negedge clock) begin
    a_sampled <= a;
end

initial begin
    state = STATE_IDLE;
    p = 0;
    q = 0;
    a_sampled = 0;
end

endmodule