module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state; // 3 states: IDLE (0), RECEIVE (1), STOP (2), START (3)
reg [2:0] counter; // counter for the 8 data bits
reg [7:0] data; // register to store the received data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        counter <= 0;
        data <= 8'd0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 3; // START
                end else begin
                    state <= 0; // stay in IDLE
                end
            end
            3: begin // START
                state <= 1; // RECEIVE
            end
            1: begin // RECEIVE
                data <= {data[6:0], in}; // shift in the data bit
                counter <= counter + 1;
                if (counter == 8) begin
                    state <= 2; // STOP
                end
            end
            2: begin // STOP
                if (in) begin // stop bit detected
                    out_byte <= data; // output the received data byte
                    done <= 1;
                    state <= 0; // IDLE
                    counter <= 0;
                end else begin // stop bit not detected
                    state <= 2; // stay in STOP
                end
            end
            default: state <= 0;
        endcase
    end
end

// The out_byte is valid only when done is high
// done is asserted only when a stop bit is detected
always @(posedge clk) begin
    if (state == 2 && in) begin
        done <= 1;
    end else begin
        done <= 0;
    end
end

endmodule