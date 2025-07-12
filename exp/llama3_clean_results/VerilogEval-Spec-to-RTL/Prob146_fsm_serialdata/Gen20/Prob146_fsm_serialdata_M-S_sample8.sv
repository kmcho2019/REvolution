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
                    state <= 1; // START_DATA
                    bit_pos <= 0;
                end
            end
            1: begin // START_DATA
                if (bit_pos < 8) begin
                    out_byte[7 - bit_pos] <= in; // Update out_byte in the correct order
                    bit_pos <= bit_pos + 1;
                end
                else if (in) begin // STOP
                    done <= 1;
                    state <= 0; // IDLE
                    bit_pos <= 0;
                end
                else begin // Incorrect stop bit
                    state <= 2; // WAIT_STOP
                end
            end
            2: begin // WAIT_STOP
                if (in) begin
                    state <= 0; // IDLE
                end
            end
        endcase
        if (state != 1 || bit_pos < 8) begin
            done <= 0;
        end
    end
end

endmodule