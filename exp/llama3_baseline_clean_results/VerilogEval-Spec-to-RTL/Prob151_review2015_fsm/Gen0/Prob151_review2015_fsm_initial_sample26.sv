module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] shift_count;
reg [3:0] state;

parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNT = 4'd2;
parameter DONE = 4'd3;
parameter ACK = 4'd4;
parameter RESET = 4'd5;

reg [3:0] pattern_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_count <= 4'd0;
        pattern_reg <= 4'd0;
    end
    else begin
        case(state)
            IDLE: begin
                // assuming data is a single bit input
                pattern_reg <= {pattern_reg[2:0], data};
                if(pattern_reg == 4'b1101) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                shift_count <= shift_count + 1;
                if(shift_count == 4'd3) begin
                    shift_ena <= 1'b0;
                    state <= COUNT;
                    counting <= 1'b1;
                end
            end
            COUNT: begin
                if(done_counting) begin
                    counting <= 1'b0;
                    state <= DONE;
                    done <= 1'b1;
                end
            end
            DONE: begin
                if(ack) begin
                    done <= 1'b0;
                    state <= ACK;
                end
            end
            ACK: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule