module TopModule (
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
localparam START_DETECTED = 3'b001;
localparam SHIFT_BITS = 3'b010;
localparam COUNTING = 3'b011;
localparam DONE = 3'b100;

reg [3:0] sequence;
reg sequence_detected;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        sequence <= 4'b0;
        sequence_detected <= 1'b0;
        shift_count <= 4'b0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                sequence <= {data, sequence[3:1]};
                if (sequence == 4'b1101) begin
                    state <= START_DETECTED;
                    sequence_detected <= 1'b1;
                end
            end
            START_DETECTED: begin
                state <= SHIFT_BITS;
                shift_ena <= 1'b1;
            end
            SHIFT_BITS: begin
                if (shift_count == 4'b1000) begin
                    shift_ena <= 1'b0;
                    state <= COUNTING;
                    counting <= 1'b1;
                end else begin
                    shift_count <= shift_count + 1'b1;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    counting <= 1'b0;
                    state <= DONE;
                    done <= 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule