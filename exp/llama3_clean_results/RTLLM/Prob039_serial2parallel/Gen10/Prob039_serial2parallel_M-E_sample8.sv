module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] fsm_state;
reg [7:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fsm_state <= 3'b000;
        shift_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (fsm_state)
            3'b000: begin // IDLE state
                if (din_valid) begin
                    fsm_state <= 3'b001;
                    shift_reg <= {7'b0000000, din_serial};
                end else begin
                    fsm_state <= 3'b000;
                end
            end
            3'b001: begin // RECEIVE state
                if (din_valid) begin
                    shift_reg <= {shift_reg[6:0], din_serial};
                    if (fsm_state == 3'b111) begin
                        fsm_state <= 3'b000;
                        dout_parallel <= shift_reg;
                        dout_valid <= 1'b1;
                    end else begin
                        fsm_state <= fsm_state + 1'b1;
                    end
                end else begin
                    fsm_state <= 3'b000;
                end
            end
            default: begin
                if (din_valid) begin
                    shift_reg <= {shift_reg[6:0], din_serial};
                    if (fsm_state == 3'b111) begin
                        fsm_state <= 3'b000;
                        dout_parallel <= shift_reg;
                        dout_valid <= 1'b1;
                    end else begin
                        fsm_state <= fsm_state + 1'b1;
                    end
                end else begin
                    fsm_state <= 3'b000;
                end
            end
        endcase
    end
end

endmodule