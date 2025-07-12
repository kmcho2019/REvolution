module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // 0: idle, 1: start, 2: data, 3: stop
reg [2:0] bit_count; // counter for data bits
reg [7:0] data_byte; // data byte being received

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // idle
        done <= 0;
        out_byte <= 0;
        bit_count <= 0;
        data_byte <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (~in) begin // start bit detected
                    state <= 1; // start
                    data_byte <= 0;
                    bit_count <= 0;
                end
            end
            1: begin // start
                state <= 2; // data
            end
            2: begin // data
                data_byte[bit_count] <= in;
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin
                    state <= 3; // stop
                end
            end
            3: begin // stop
                if (in) begin // stop bit correct
                    state <= 0; // idle
                    done <= 1;
                    out_byte <= data_byte;
                end else begin // stop bit incorrect
                    state <= 0; // idle
                    done <= 0;
                    out_byte <= 0;
                end
            end
            default: begin
                state <= 0; // idle
            end
        endcase
        if (state != 3) begin
            done <= 0;
        end
    end
end

endmodule