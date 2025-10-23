module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] state;
reg [3:0] shift_reg;

parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNT = 4'd2;
parameter DONE_ACK = 4'd3;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        shift_reg <= 4'd0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                shift_reg <= {data, shift_reg[3:1]};
                if(shift_reg == 4'b1101) begin
                    state <= SHIFT;
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if(shift_reg[0] == 1'b1) begin
                    shift_reg <= {data, shift_reg[3:1]};
                    if(shift_reg[3:0] == 4'b1111) begin
                        state <= COUNT;
                    end
                end else begin
                    shift_reg <= {data, shift_reg[3:1]};
                    if(shift_reg[3:0] == 4'b0000) begin
                        state <= COUNT;
                    end
                end
            end
            COUNT: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                if(done_counting) begin
                    state <= DONE_ACK;
                end
            end
            DONE_ACK: begin
                counting <= 1'b0;
                done <= 1'b1;
                if(ack) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule