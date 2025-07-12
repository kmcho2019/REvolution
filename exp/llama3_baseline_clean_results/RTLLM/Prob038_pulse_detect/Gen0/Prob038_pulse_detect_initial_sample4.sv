module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [1:0] state;
reg [1:0] next_state;
reg data_out_reg;

parameter IDLE = 2'b00;
parameter PULSE_START = 2'b01;
parameter PULSE_END = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out_reg <= 0;
    end else begin
        state <= next_state;
        data_out_reg <= (state == PULSE_END) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = PULSE_START;
            end else begin
                next_state = IDLE;
            end
        end
        PULSE_START: begin
            if (~data_in) begin
                next_state = PULSE_END;
            end else begin
                next_state = PULSE_START;
            end
        end
        PULSE_END: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

assign data_out = (state == PULSE_END) ? 1'b1 : (next_state == PULSE_END) ? 1'b1 : 1'b0;

endmodule