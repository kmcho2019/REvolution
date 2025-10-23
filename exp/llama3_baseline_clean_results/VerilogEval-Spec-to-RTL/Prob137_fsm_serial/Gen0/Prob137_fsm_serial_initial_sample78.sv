module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

    reg [2:0] state; // 3 states: IDLE, STARTED, STOPPED, ERROR
    reg [7:0] data; // 8-bit shift register
    reg [2:0] count; // 3-bit counter
    reg done_reg; // done signal register

    // State encoding
    parameter IDLE = 3'b000;
    parameter STARTED = 3'b001;
    parameter STOPPED = 3'b010;
    parameter ERROR = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 3'b000;
            data <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin // start bit detected
                        state <= STARTED;
                        count <= 3'b000;
                        data <= 8'b0;
                    end else begin
                        state <= IDLE;
                    end
                end
                STARTED: begin
                    data <= {data[6:0], in}; // shift in data bit
                    count <= count + 1'b1;
                    if (count == 3'b100) begin // 8 bits received
                        state <= STOPPED;
                    end else begin
                        state <= STARTED;
                    end
                end
                STOPPED: begin
                    if (in) begin // stop bit detected
                        state <= IDLE;
                        done_reg <= 1'b1;
                    end else begin
                        state <= ERROR;
                    end
                end
                ERROR: begin
                    if (in) begin // stop bit detected
                        state <= IDLE;
                    end else begin
                        state <= ERROR;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Continuous assignment for done signal
    assign done = done_reg;
    always @(posedge clk) begin
        if (state == IDLE) begin
            done_reg <= 1'b0;
        end
    end

endmodule