module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,
    BIT3,
    BIT2,
    BIT1,
    BIT0
} state, next_state;

// Register to store the parallel input
reg [3:0] data_reg;

// Output register to store the serial output
reg dout_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_reg <= 4'b0;
        dout_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (d != 4'b0) begin
                    data_reg <= d;
                    state <= BIT3;
                end
            end
            BIT3: begin
                dout_reg <= data_reg[3];
                state <= BIT2;
            end
            BIT2: begin
                dout_reg <= data_reg[2];
                state <= BIT1;
            end
            BIT1: begin
                dout_reg <= data_reg[1];
                state <= BIT0;
            end
            BIT0: begin
                dout_reg <= data_reg[0];
                state <= IDLE;
            end
        endcase
    end
end

assign valid_out = (state != IDLE) ? 1'b1 : 1'b0;
assign dout = dout_reg;

endmodule