module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

typedef enum logic [1:0] {
    S_IDLE,
    S_BIT0,
    S_BIT1,
    S_BIT2
} state_t;

state_t state, next_state;
reg [3:0] data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_IDLE;
        data <= 0;
    end else begin
        state <= next_state;
        if (state == S_IDLE) begin
            data <= d;
        end
    end
end

always @(*) begin
    case (state)
        S_IDLE: begin
            next_state = S_BIT0;
            valid_out = 1'b1;
            dout = data[3];
        end
        S_BIT0: begin
            next_state = S_BIT1;
            valid_out = 1'b0;
            dout = data[2];
        end
        S_BIT1: begin
            next_state = S_BIT2;
            valid_out = 1'b0;
            dout = data[1];
        end
        S_BIT2: begin
            next_state = S_IDLE;
            valid_out = 1'b0;
            dout = data[0];
        end
        default: begin
            next_state = S_IDLE;
            valid_out = 1'b0;
            dout = 1'b0;
        end
    endcase
end

endmodule