module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state; // IDLE = 0, DATA = 1, STOP = 2, WAIT_STOP = 3
reg [7:0] data_byte; // register to store the received data byte
reg [2:0] count; // counter to count the number of data bits received
reg done_reg; // register to store the done signal

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset the state to IDLE
        data_byte <= 8'b0; // reset the data byte to 0
        count <= 0; // reset the counter to 0
        done_reg <= 0; // reset the done signal to 0
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // start bit detected
                    state <= 1; // transition to DATA state
                    count <= 0; // reset the counter
                    data_byte <= 8'b0; // reset the data byte
                end
            end
            1: begin // DATA
                data_byte <= {data_byte[6:0], in}; // shift in the received data bit
                count <= count + 1; // increment the counter
                if (count == 7) begin // all 8 data bits received
                    state <= 2; // transition to STOP state
                end
            end
            2: begin // STOP
                if (in) begin // stop bit detected
                    state <= 0; // transition to IDLE state
                    done_reg <= 1; // assert the done signal
                end else begin
                    state <= 3; // transition to WAIT_STOP state
                end
            end
            3: begin // WAIT_STOP
                if (in) begin // stop bit detected
                    state <= 0; // transition to IDLE state
                    done_reg <= 1; // assert the done signal
                end
            end
        endcase
    end
end

assign out_byte = data_byte; // assign the received data byte to the output
assign done = done_reg; // assign the done signal to the output

endmodule