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

reg [3:0] state;
reg [3:0] shift_count;

// Define states
localparam IDLE = 4'd0;
localparam SHIFT = 4'd1;
localparam COUNTING = 4'd2;
localparam DONE = 4'd3;

// Define shift count
reg [3:0] shift_pattern;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 4'd0;
        shift_pattern <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                if (shift_pattern == 4'd13) begin // 1101
                    state <= SHIFT;
                    shift_pattern <= 4'd0;
                end else begin
                    shift_pattern <= {shift_pattern[2:0], data};
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if (shift_count == 4'd3) begin
                    state <= COUNTING;
                    shift_count <= 4'd0;
                end else begin
                    shift_count <= shift_count + 1'd1;
                end
            end
            COUNTING: begin
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        SHIFT: begin
            counting = 1'b0;
            done = 1'b0;
        end
        COUNTING: begin
            shift_ena = 1'b0;
            done = 1'b0;
        end
        DONE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
        end
        default: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

endmodule