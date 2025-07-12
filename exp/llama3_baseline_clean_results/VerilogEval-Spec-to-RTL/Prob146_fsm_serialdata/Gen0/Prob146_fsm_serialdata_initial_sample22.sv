module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

enum logic [2:0] {IDLE, DATA, STOP} state, next_state;

logic [2:0] data_count;
logic [7:0] data_byte;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 0;
        data_byte <= 0;
        out_byte <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (!in) begin
                    next_state <= DATA;
                    data_count <= 1;
                    data_byte <= {7'b0, in};
                end else begin
                    next_state <= IDLE;
                    data_count <= 0;
                end
            end
            DATA: begin
                if (data_count < 8) begin
                    next_state <= DATA;
                    data_count <= data_count + 1;
                    data_byte <= {data_byte[6:0], in};
                end else begin
                    next_state <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    next_state <= IDLE;
                    out_byte <= data_byte;
                    done <= 1;
                end else begin
                    next_state <= STOP;
                    done <= 0;
                end
            end
            default: next_state <= IDLE;
        endcase
    end
end

always_comb begin
    case (state)
        IDLE: done = 0;
        DATA: done = 0;
        STOP: done = in;
        default: done = 0;
    endcase
end

endmodule