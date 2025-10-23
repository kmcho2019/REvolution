module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] next_state;
reg [7:0] data;
reg [3:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        data <= 8'b0;
        bit_counter <= 0;
        done <= 0;
    end else begin
        case(state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1; // START
                    bit_counter <= 0;
                end else begin
                    state <= 0; // IDLE
                end
            end
            1: begin // START
                state <= 2; // DATA
                bit_counter <= 1;
            end
            2: begin // DATA
                data <= {data[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 8) begin
                    state <= 3; // STOP
                end else begin
                    state <= 2; // DATA
                end
            end
            3: begin // STOP
                if (in) begin // stop bit is 1
                    state <= 0; // IDLE
                    out_byte <= data;
                    done <= 1;
                end else begin
                    state <= 3; // wait for stop bit
                end
            end
            default: state <= 0; // IDLE
        endcase
    end
end

endmodule