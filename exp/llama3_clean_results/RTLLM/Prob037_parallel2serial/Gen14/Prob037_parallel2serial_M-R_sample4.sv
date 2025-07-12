module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

enum logic [1:0] {IDLE, BIT0, BIT1, BIT2, BIT3} state, next_state;
reg [3:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_reg <= 4'b0;
    end else begin
        state <= next_state;
        if (next_state == IDLE) begin
            data_reg <= d;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            next_state = BIT0;
            valid_out = 1'b1;
            dout = data_reg[3];
        end
        BIT0: begin
            next_state = BIT1;
            valid_out = 1'b0;
            dout = data_reg[2];
        end
        BIT1: begin
            next_state = BIT2;
            valid_out = 1'b0;
            dout = data_reg[1];
        end
        BIT2: begin
            next_state = BIT3;
            valid_out = 1'b0;
            dout = data_reg[0];
        end
        BIT3: begin
            next_state = IDLE;
            valid_out = 1'b0;
            dout = 1'b0;
        end
        default: begin
            next_state = IDLE;
            valid_out = 1'b0;
            dout = 1'b0;
        end
    endcase
end

endmodule