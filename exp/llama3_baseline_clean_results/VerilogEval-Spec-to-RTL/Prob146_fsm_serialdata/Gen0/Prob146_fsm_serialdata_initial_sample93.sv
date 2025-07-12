module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data;
reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: INVALID_STOP
reg [2:0] bit_count;
reg out_done;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_count <= 0;
        out_done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // start bit detected
                    state <= 1; // START
                    data <= 8'b0;
                    bit_count <= 0;
                end else begin
                    state <= 0; // stay in IDLE
                end
            end
            1: begin // START
                state <= 2; // DATA
                bit_count <= 0;
            end
            2: begin // DATA
                data[bit_count] <= in;
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin
                    state <= 3; // STOP
                end else begin
                    state <= 2; // stay in DATA
                end
            end
            3: begin // STOP
                if (in) begin // stop bit verified
                    state <= 0; // IDLE
                    out_done <= 1;
                end else begin
                    state <= 4; // INVALID_STOP
                end
            end
            4: begin // INVALID_STOP
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                end else begin
                    state <= 4; // stay in INVALID_STOP
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        out_byte <= 8'b0;
        done <= 0;
    end else begin
        if (out_done) begin
            out_byte <= {data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]}; // output the received byte in the correct order (MSB first)
            done <= 1;
            out_done <= 0;
        end else begin
            done <= 0;
        end
    end
end

endmodule