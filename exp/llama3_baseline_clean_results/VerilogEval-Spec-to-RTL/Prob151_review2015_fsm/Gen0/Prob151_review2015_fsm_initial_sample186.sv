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

reg [3:0] shift_reg;
reg [1:0] shift_cnt;
reg [2:0] state;

localparam IDLE = 3'b000;
localparam SHIFT = 3'b001;
localparam COUNTING = 3'b010;
localparam DONE = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_reg <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_cnt <= 2'b00;
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                shift_cnt <= shift_cnt + 1'b1;
                if (shift_cnt == 2'b11) begin
                    state <= COUNTING;
                    shift_ena <= 1'b0;
                end
            end
            COUNTING: begin
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONE;
                    counting <= 1'b0;
                end
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule