module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte;
reg done;
reg [2:0] state; // 0: IDLE, 1: START_BIT, 2: DATA_BITS, 3: STOP_BIT
reg [7:0] data;
reg [2:0] bit_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
        out_byte <= 0;
        bit_count <= 0;
        data <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START_BIT
                    data <= 0;
                    bit_count <= 0;
                end else begin
                    state <= 0; // IDLE
                end
            end
            1: begin // START_BIT
                state <= 2; // DATA_BITS
            end
            2: begin // DATA_BITS
                data[bit_count] <= in;
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin
                    state <= 3; // STOP_BIT
                end else begin
                    state <= 2; // DATA_BITS
                end
            end
            3: begin // STOP_BIT
                if (in) begin // stop bit detected
                    done <= 1;
                    out_byte <= data;
                    state <= 0; // IDLE
                end else begin // incorrect stop bit, wait for stop bit
                    state <= 3; // STOP_BIT
                end
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    if (state != 3) begin // not in STOP_BIT state
        done <= 0;
    end
end

endmodule