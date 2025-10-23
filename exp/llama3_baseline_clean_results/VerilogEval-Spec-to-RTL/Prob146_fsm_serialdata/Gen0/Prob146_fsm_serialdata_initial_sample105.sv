module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] counter; // Counter for data bits
reg [7:0] data_byte; // Temporary storage for received data byte

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
        counter <= 0;
        out_byte <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // Start bit detected
                    state <= 1; // START
                    data_byte <= 0;
                    counter <= 0;
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                data_byte[7 - counter] <= in;
                counter <= counter + 1;
                if (counter == 8) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // Stop bit detected
                    done <= 1;
                    out_byte <= data_byte;
                end else begin
                    state <= 3; // Stay in STOP state until stop bit is detected
                end
            end
            default: state <= 0; // IDLE
        endcase
        if (state != 3 || in) begin
            done <= 0;
        end
    end
end

endmodule