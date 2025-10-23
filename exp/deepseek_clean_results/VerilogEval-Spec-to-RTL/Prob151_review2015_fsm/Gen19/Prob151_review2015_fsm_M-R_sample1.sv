module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // Binary state encoding
    localparam IDLE   = 2'b00;
    localparam SHIFT  = 2'b01;
    localparam COUNT  = 2'b10;
    localparam DONE   = 2'b11;

    reg [1:0] state;
    reg [2:0] seq_match;  // Tracks progress in 1101 sequence
    reg [1:0] shift_ctr;  // Counts 4 shift cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            seq_match <= 3'b0;
            shift_ctr <= 2'b0;
            {shift_ena, counting, done} <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Track sequence 1101 (MSB first)
                    seq_match <= {seq_match[1:0], data};
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;

                    if (seq_match == 3'b110 && data == 1'b1) begin
                        state <= SHIFT;
                        shift_ctr <= 2'b0;
                    end
                end

                SHIFT: begin
                    shift_ena <= 1'b1;
                    shift_ctr <= shift_ctr + 1'b1;

                    if (shift_ctr == 2'd3) begin
                        state <= COUNT;
                        shift_ena <= 1'b0;
                    end
                end

                COUNT: begin
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
                        seq_match <= 3'b0;
                    end
                end
            endcase
        end
    end

endmodule