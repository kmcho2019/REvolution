module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [2:0] bit_pos;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_pos <= 0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                out_byte[bit_pos] <= in;
                if (bit_pos == 7) begin
                    state <= 3; // STOP
                end
                else begin
                    bit_pos <= bit_pos + 1;
                end
            end
            3: begin // STOP
                if (in) begin
                    done <= 1;
                    state <= 0; // IDLE
                    bit_pos <= 0;
                end
                else begin
                    state <= 4; // WAIT_STOP
                end
            end
            4: begin // WAIT_STOP
                if (in) begin
                    state <= 0; // IDLE
                    bit_pos <= 0;
                end
            end
            default: begin
                state <= 0; // IDLE
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 3) begin
        done <= 1;
    end
    else begin
        done <= 0;
    end
end

endmodule