module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] state;
reg [3:0] shift_counter;
reg [3:0] pattern_counter;

localparam IDLE      = 4'd0;
localparam SHIFT     = 4'd1;
localparam COUNTING  = 4'd2;
localparam DONE_WAIT = 4'd3;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_counter <= 4'd0;
        pattern_counter <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                if (pattern_counter == 4'd4) begin
                    pattern_counter <= 4'd0;
                    state <= SHIFT;
                    shift_ena <= 1'b1;
                    shift_counter <= 4'd1;
                end else if (data == 1'b1 && pattern_counter == 4'd0) begin
                    pattern_counter <= 4'd1;
                end else if (data == 1'b1 && pattern_counter == 4'd1) begin
                    pattern_counter <= 4'd2;
                end else if (data == 1'b0 && pattern_counter == 4'd2) begin
                    pattern_counter <= 4'd3;
                end else if (data == 1'b1 && pattern_counter == 4'd3) begin
                    pattern_counter <= 4'd4;
                end else begin
                    pattern_counter <= 4'd0;
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if (shift_counter == 4'd4) begin
                    shift_ena <= 1'b0;
                    state <= COUNTING;
                    counting <= 1'b1;
                    shift_counter <= 4'd0;
                end else begin
                    shift_counter <= shift_counter + 4'd1;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    counting <= 1'b0;
                    state <= DONE_WAIT;
                    done <= 1'b1;
                end
            end
            DONE_WAIT: begin
                if (ack) begin
                    done <= 1'b0;
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule