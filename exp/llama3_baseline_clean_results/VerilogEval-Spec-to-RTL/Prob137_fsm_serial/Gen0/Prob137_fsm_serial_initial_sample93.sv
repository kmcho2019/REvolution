module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // IDLE, RECEIVE, STOP
reg [7:0] data; // To store the received data bits
reg [3:0] counter; // To count the received bits

parameter IDLE = 3'b001;
parameter RECEIVE = 3'b010;
parameter STOP = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counter <= 0;
        data <= 0;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (!in) begin // Start bit detected
                    state <= RECEIVE;
                    data <= 0; // Reset data for new byte
                    counter <= 0; // Reset counter
                end
            end
            RECEIVE: begin
                data <= {in, data[7:1]}; // Shift in the new bit, MSB to LSB
                counter <= counter + 1;
                if (counter == 8) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Correct stop bit received
                    done <= 1; // Signal that a byte is received
                    state <= IDLE;
                end else begin // Incorrect stop bit, wait for a stop bit
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if (state == IDLE && in) begin // If idle and line is high, no need to do anything
        done <= 0; // Reset done signal when in IDLE and line is high
    end
end

endmodule