module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state;
reg [3:0] shift_reg;

localparam IDLE = 2'd0;
localparam SHIFT = 2'd1;
localparam COUNT = 2'd2;
localparam DONE = 2'd3;

reg [1:0] shift_cnt;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        shift_cnt <= 2'd0;
    end
    else begin
        case(state)
            IDLE: begin
                shift_reg <= {shift_reg[2:0], data};
                if(shift_reg == 4'd13) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                if(shift_cnt < 4'd4) begin
                    shift_cnt <= shift_cnt + 1;
                end
                else begin
                    shift_cnt <= 2'd0;
                    state <= COUNT;
                end
            end
            COUNT: begin
                if(done_counting) begin
                    state <= DONE;
                end
            end
            DONE: begin
                if(ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            shift_ena = 1'd0;
            counting = 1'd0;
            done = 1'd0;
        end
        SHIFT: begin
            shift_ena = 1'd1;
            counting = 1'd0;
            done = 1'd0;
        end
        COUNT: begin
            shift_ena = 1'd0;
            counting = 1'd1;
            done = 1'd0;
        end
        DONE: begin
            shift_ena = 1'd0;
            counting = 1'd0;
            done = 1'd1;
        end
    endcase
end

endmodule