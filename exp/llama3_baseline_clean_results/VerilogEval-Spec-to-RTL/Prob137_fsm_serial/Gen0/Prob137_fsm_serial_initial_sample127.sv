module TopModule(
    input       clk,
    input       reset,
    input       in,
    output      done
);

reg [7:0] data;
reg [2:0] state; // 0: Idle, 1: Receiving, 2: Verify Stop
reg [3:0] bit_count;
reg done_flag;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_flag <= 0;
        bit_count <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (~in) begin // Start bit detected
                    state <= 1;
                    bit_count <= 1;
                    data <= {7'b0, in};
                end
            end
            1: begin // Receiving
                bit_count <= bit_count + 1;
                data <= {data[6:0], in};
                if (bit_count == 8) begin
                    state <= 2;
                end
            end
            2: begin // Verify Stop
                if (in) begin // Correct stop bit
                    done_flag <= 1;
                    state <= 0;
                end else begin // Incorrect stop bit, wait for line to go idle
                    if (~in) begin
                        state <= 0;
                    end
                end
            end
        endcase
    end
end

assign done = done_flag;

always @(posedge clk) begin
    if (reset || (state == 0)) begin
        done_flag <= 0;
    end
end

endmodule