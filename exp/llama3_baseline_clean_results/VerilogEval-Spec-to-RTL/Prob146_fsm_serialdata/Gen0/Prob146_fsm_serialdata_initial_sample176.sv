module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

enum logic [1:0] {IDLE, START, DATA, STOP} state, next_state;

logic [2:0] bit_count;
logic [7:0] data_byte;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= START;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                state <= DATA;
                bit_count <= 3'b000;
                data_byte <= 8'b0;
            end
            DATA: begin
                data_byte <= {data_byte[6:0], in};
                bit_count <= bit_count + 1'b1;
                if (bit_count == 3'b111) begin
                    state <= STOP;
                end else begin
                    state <= DATA;
                end
            end
            STOP: begin
                if (in) begin
                    out_byte <= data_byte;
                    done <= 1'b1;
                    state <= IDLE;
                end else begin
                    state <= STOP;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always_comb begin
    if (state == STOP) begin
        done = 1'b1;
    end else begin
        done = 1'b0;
    end
end

endmodule