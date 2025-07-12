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

reg [2:0] state;
reg [1:0] shift_count;
reg [3:0] pattern;

localparam IDLE = 3'b000;
localparam SHIFT = 3'b001;
localparam COUNTING = 3'b010;
localparam DONE = 3'b011;

reg shift_ena_reg, counting_reg, done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 2'b00;
        pattern <= 4'b0000;
        shift_ena_reg <= 1'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_count <= 2'b00;
                    shift_ena_reg <= 1'b1;
                end else begin
                    state <= IDLE;
                    shift_ena_reg <= 1'b0;
                end
            end
            SHIFT: begin
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin
                    state <= COUNTING;
                    shift_ena_reg <= 1'b0;
                    counting_reg <= 1'b1;
                end else begin
                    state <= SHIFT;
                    shift_ena_reg <= 1'b1;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    state <= DONE;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b1;
                end else begin
                    state <= COUNTING;
                    counting_reg <= 1'b1;
                    done_reg <= 1'b0;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                end else begin
                    state <= DONE;
                    done_reg <= 1'b1;
                end
            end
            default: begin
                state <= IDLE;
                shift_ena_reg <= 1'b0;
                counting_reg <= 1'b0;
                done_reg <= 1'b0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule