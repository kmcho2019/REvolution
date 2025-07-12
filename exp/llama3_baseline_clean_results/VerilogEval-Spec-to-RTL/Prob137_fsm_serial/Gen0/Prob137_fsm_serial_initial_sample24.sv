module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // IDLE, START, DATA, STOP
reg [2:0] data_count;
reg [7:0] data;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        data_count <= 0;
        data <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                end else begin
                    state <= 0; // IDLE
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                data_count <= data_count + 1;
                data[data_count - 1] <= in;
                if (data_count == 8) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    done <= 1;
                    state <= 0; // IDLE
                end else begin
                    state <= 3; // STOP
                end
            end
            default: begin
                state <= 0; // IDLE
            end
        endcase
        if (state != 3) begin // not in STOP state
            done <= 0;
        end
    end
end

endmodule