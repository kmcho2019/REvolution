module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b011, ERROR = 3'b100
reg [7:0] data;
reg [2:0] data_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // IDLE
        data <= 8'b0;
        data_count <= 3'b0;
        done <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 3'b001; // START
                end
            end
            3'b001: begin // START
                state <= 3'b010; // DATA
                data_count <= 3'b000;
                data[0] <= in;
            end
            3'b010: begin // DATA
                data_count <= data_count + 1;
                data[data_count] <= in;
                if (data_count == 3'b111) begin // all 8 data bits received
                    state <= 3'b011; // STOP
                end
            end
            3'b011: begin // STOP
                if (in) begin // stop bit correct
                    done <= 1'b1;
                    state <= 3'b000; // IDLE
                end else begin // stop bit incorrect
                    state <= 3'b100; // ERROR
                end
            end
            3'b100: begin // ERROR
                if (in) begin // stop bit detected, transition back to IDLE
                    state <= 3'b000; // IDLE
                end
            end
            default: begin
                state <= 3'b000; // IDLE
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 3'b000) begin // IDLE
        done <= 1'b0;
    end
end

endmodule