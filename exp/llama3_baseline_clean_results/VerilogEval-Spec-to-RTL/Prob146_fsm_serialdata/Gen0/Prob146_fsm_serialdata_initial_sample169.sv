module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [7:0] data;
reg [2:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
        out_byte <= 0;
        data <= 0;
        count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // RECEIVE_BYTE
                    data <= 0;
                    count <= 0;
                end
            end
            1: begin // RECEIVE_BYTE
                data <= {data[6:0], in}; // shift in bit
                if (count == 7) begin // 8 bits received
                    state <= 2; // VERIFY_STOP
                end else begin
                    count <= count + 1;
                end
            end
            2: begin // VERIFY_STOP
                if (in) begin // stop bit correct
                    state <= 0; // IDLE
                    out_byte <= data;
                    done <= 1;
                end else begin
                    state <= 3; // WAIT_FOR_IDLE
                end
            end
            3: begin // WAIT_FOR_IDLE
                if (in) begin // line is idle
                    state <= 0; // IDLE
                end
            end
        endcase
        if (state != 2) begin // reset done signal
            done <= 0;
        end
    end
end

endmodule