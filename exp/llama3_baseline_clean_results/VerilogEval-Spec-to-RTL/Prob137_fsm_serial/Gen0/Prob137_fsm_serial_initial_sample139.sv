module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // IDLE, START, DATA, STOP, ERROR
reg [7:0] data; // To store the received data
reg [2:0] counter; // Counter for data bits
reg done_reg; // To synchronize done signal

localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;
localparam ERROR = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
        counter <= 3'b000;
        data <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= START;
                    counter <= 3'b000;
                    data <= 8'b0;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                state <= DATA;
                counter <= 3'b001;
                data[0] <= in;
            end
            DATA: begin
                counter <= counter + 1;
                data[counter-1] <= in;
                if (counter == 3'b100) begin
                    state <= STOP;
                end else begin
                    state <= DATA;
                end
            end
            STOP: begin
                if (in) begin // Stop bit is correct
                    state <= IDLE;
                    done_reg <= 1'b1;
                end else begin // Stop bit is incorrect
                    state <= ERROR;
                end
            end
            ERROR: begin
                if (in) begin
                    state <= IDLE;
                end else begin
                    state <= ERROR;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    done <= done_reg;
    if (state != IDLE) begin
        done_reg <= 1'b0;
    end
end

endmodule