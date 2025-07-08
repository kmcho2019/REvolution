module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        RECEIVE = 2'd1,
        STOP = 2'd2,
        WAIT_STOP = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done pulse
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end
                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]}; // shift in LSB first, so MSB is last shifted in
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin // valid stop bit
                        out_byte <= data_shift;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end
                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule