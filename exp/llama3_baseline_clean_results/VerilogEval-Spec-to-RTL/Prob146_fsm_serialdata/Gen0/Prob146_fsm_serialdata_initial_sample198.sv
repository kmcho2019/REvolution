module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // IDLE, START, DATA, STOP, ERROR
reg [2:0] data_count; // Count of received data bits
reg [7:0] data; // Received data byte

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
        data_count <= 0;
        data <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in == 0) begin
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
                data_count <= 0;
            end
            2: begin // DATA
                data <= {data[6:0], in};
                data_count <= data_count + 1;
                if (data_count == 7) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in == 1) begin
                    state <= 0; // IDLE
                    out_byte <= data;
                    done <= 1;
                end else begin
                    state <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in == 1) begin
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
        if (state != 3) begin // STOP
            done <= 0;
        end
    end
end

endmodule