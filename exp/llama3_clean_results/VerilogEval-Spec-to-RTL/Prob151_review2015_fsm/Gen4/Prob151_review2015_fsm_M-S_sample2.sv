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

reg [2:0] state;
reg [3:0] shift_count;

localparam IDLE = 3'b000;
localparam PATTERN_DETECTED = 3'b001;
localparam SHIFTING = 3'b010;
localparam COUNTING = 3'b011;
localparam DONE = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin // pattern detection logic
                    state <= PATTERN_DETECTED;
                end else begin
                    state <= IDLE;
                end
            end
            PATTERN_DETECTED: begin
                shift_ena <= 1'b1;
                state <= SHIFTING;
            end
            SHIFTING: begin
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    shift_ena <= 1'b0;
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                counting <= 1'b1;
                if (done_counting) begin
                    counting <= 1'b0;
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    done <= 1'b0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule