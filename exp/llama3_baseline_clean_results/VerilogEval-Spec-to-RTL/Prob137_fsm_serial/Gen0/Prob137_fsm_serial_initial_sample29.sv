module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state; // 3 states: IDLE, RECEIVE, STOP
reg [7:0] data; // 8-bit shift register to store received data bits
reg [2:0] count; // 3-bit counter to count received bits
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        count <= 0;
        done_reg <= 0;
        data <= 8'b0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (!in) begin // start bit detected
                    state <= 1; // move to RECEIVE state
                    count <= 1; // set count to 1
                    data[0] <= in; // store start bit
                end else begin
                    state <= 0; // stay in IDLE state
                end
            end
            1: begin // RECEIVE state
                if (count < 8) begin // if not all bits received
                    data[count] <= in; // store received bit
                    count <= count + 1; // increment count
                    state <= 1; // stay in RECEIVE state
                end else begin // if all bits received
                    state <= 2; // move to STOP state
                end
                if (in) begin // if input is 1 instead of 0
                    state <= 0; // move to IDLE state
                    count <= 0; // reset count
                end
            end
            2: begin // STOP state
                if (in) begin // stop bit verified
                    done_reg <= 1; // set done signal high
                    state <= 0; // move to IDLE state
                    count <= 0; // reset count
                end else begin // stop bit not verified
                    state <= 0; // move to IDLE state
                    count <= 0; // reset count
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    done <= done_reg;
    done_reg <= 0;
end

endmodule