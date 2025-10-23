module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [7:0] data; // stores the received data
reg [2:0] state; // 3 states: IDLE, START, DATA, STOP, DONE
reg done_reg; // register for output done

// Define state encodings
parameter IDLE = 3'b001;
parameter START = 3'b010;
parameter DATA = 3'b011;
parameter STOP = 3'b100;
parameter DONE_STATE = 3'b101;

// Initialize state and done_reg
initial begin
    state = IDLE;
    done_reg = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= START;
                    data <= 8'b0; // clear data
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                data[0] <= in; // store the first data bit (LSB)
                state <= DATA;
            end
            DATA: begin
                if (data[7] == 1'b0) begin // check if all bits have been shifted
                    data <= {data[6:0], in}; // shift in the new data bit
                end else begin
                    if (in) begin
                        state <= STOP;
                    end else begin
                        state <= DATA;
                    end
                end
            end
            STOP: begin
                if (in) begin // check if stop bit is high
                    state <= DONE_STATE;
                end else begin
                    state <= IDLE; // incorrect stop bit, go back to idle
                end
            end
            DONE_STATE: begin
                state <= IDLE;
                done_reg <= 1'b1;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

// Set done high when in DONE_STATE
always @(posedge clk) begin
    if (state == DONE_STATE) begin
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule