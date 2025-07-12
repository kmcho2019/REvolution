module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [3:0] data_count; // counter for data bits
reg [7:0] data; // register to hold received data

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        done <= 0;
        data_count <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (!in) begin // start bit detected
                    state <= 1; // transition to START state
                end
            end
            1: begin // START state
                state <= 2; // transition to DATA state
                data_count <= 1; // initialize data bit counter
                data[0] <= in; // store first data bit
            end
            2: begin // DATA state
                if (data_count < 8) begin
                    data[data_count] <= in; // store next data bit
                    data_count <= data_count + 1; // increment data bit counter
                end else begin
                    state <= 3; // transition to STOP state
                end
            end
            3: begin // STOP state
                if (in) begin // stop bit detected
                    state <= 0; // transition to IDLE state
                    done <= 1; // set done output high
                end else begin
                    state <= 0; // transition to IDLE state and wait for stop bit
                end
            end
        endcase
    end
end

always @ (negedge clk) begin
    done <= 0; // reset done output low
end

endmodule