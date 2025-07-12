module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [7:0] data; // register to store the received data
reg [2:0] state; // finite state machine state (IDLE, START, DATA, STOP)
reg [3:0] cnt; // counter for data bits
reg done_int; // internal done signal

// state encoding
localparam IDLE = 3'b001;
localparam START = 3'b010;
localparam DATA = 3'b011;
localparam STOP = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        cnt <= 4'b0000;
        data <= 8'b00000000;
        done_int <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // start bit detected
                    state <= START;
                    cnt <= 4'b0000;
                    data <= 8'b00000000;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                data <= {data[6:0], in}; // shift in the new bit
                cnt <= cnt + 1;
                if (cnt == 4'b1000) begin // 8 data bits received
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // stop bit detected
                    state <= IDLE;
                    done_int <= 1'b1;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    done <= done_int;
    done_int <= 1'b0; // clear done signal after one clock cycle
end

endmodule