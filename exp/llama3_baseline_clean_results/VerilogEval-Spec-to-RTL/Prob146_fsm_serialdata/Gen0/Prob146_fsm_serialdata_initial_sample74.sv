module TopModule(
    input           clk,
    input           in,
    input           reset,
    output [7:0]    out_byte,
    output          done
);

enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    INVALID_STOP
} state, next_state;

logic [7:0] data_byte;
logic [2:0] data_count;
logic start_bit_detected;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_byte <= 8'b0;
        data_count <= 3'b0;
        start_bit_detected <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    start_bit_detected <= 1'b1;
                    state <= START;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                data_byte <= 8'b0;
                data_count <= 3'b0;
                state <= DATA;
            end
            DATA: begin
                data_byte <= {data_byte[6:0], in};
                data_count <= data_count + 1'b1;
                if (data_count == 3'b111) begin
                    state <= STOP;
                end else begin
                    state <= DATA;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    out_byte <= data_byte;
                    done <= 1'b1;
                    state <= IDLE;
                end else begin
                    state <= INVALID_STOP;
                end
            end
            INVALID_STOP: begin
                if (in == 1'b1) begin
                    state <= IDLE;
                end else begin
                    state <= INVALID_STOP;
                end
            end
            default: state <= IDLE;
        endcase
        if (state != STOP) begin
            done <= 1'b0;
        end
    end
end

endmodule