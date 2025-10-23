module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b011
reg [3:0] data_counter; // counter for data bits
reg [7:0] data; // stores the received data byte
reg start_bit_received; // flag to check if start bit is received

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // reset to IDLE state
        done <= 1'b0;
        data_counter <= 4'b0000;
        start_bit_received <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (!in) begin // check for start bit
                    state <= 3'b001; // move to START state
                    start_bit_received <= 1'b1;
                end else begin
                    state <= 3'b000; // stay in IDLE state
                end
            end
            3'b001: begin // START state
                state <= 3'b010; // move to DATA state
                data_counter <= 4'b0001; // reset data counter
                data <= 8'b00000000; // reset data byte
                if (in) begin // if start bit was a glitch
                    state <= 3'b000; // go back to IDLE state
                    start_bit_received <= 1'b0;
                end
            end
            3'b010: begin // DATA state
                data[7 - data_counter + 1] <= in; // store the received data bit
                if (data_counter == 4'b1000) begin // if all data bits are received
                    state <= 3'b011; // move to STOP state
                end else begin
                    data_counter <= data_counter + 1; // increment data counter
                end
            end
            3'b011: begin // STOP state
                if (in) begin // check for stop bit
                    done <= 1'b1; // set done output high
                    state <= 3'b000; // move back to IDLE state
                end else begin
                    state <= 3'b011; // stay in STOP state and wait for stop bit
                end
            end
            default: state <= 3'b000; // default to IDLE state
        endcase
        if (state != 3'b011) begin // if not in STOP state
            done <= 1'b0; // reset done output
        end
    end
end

endmodule