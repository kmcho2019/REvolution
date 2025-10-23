module TopModule(
    input       clk,
    input       reset,
    input       in,
    output      done
);

reg [7:0] data;
reg [2:0] state; // 0: IDLE, 1: RECEIVING, 2: VERIFY_STOP
reg [3:0] bit_count;
reg        done_reg;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state     <= 0;
        bit_count <= 0;
        done_reg  <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state     <= 1;
                    bit_count <= 1;
                end else begin
                    state     <= 0;
                end
            end
            1: begin // RECEIVING
                data[bit_count - 1] <= in;
                if (bit_count == 8) begin
                    state     <= 2;
                    bit_count <= 0;
                end else begin
                    bit_count <= bit_count + 1;
                end
            end
            2: begin // VERIFY_STOP
                if (in) begin // stop bit detected
                    state     <= 0;
                    done_reg  <= 1;
                end else begin // incorrect stop bit, wait for stop
                    state     <= 2;
                end
            end
        endcase
    end
end

assign done = done_reg;

always @ (posedge clk) begin
    if (state == 0) begin
        done_reg <= 0;
    end
end

endmodule