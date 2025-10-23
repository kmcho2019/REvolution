module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [2:0] state; // IDLE, START, DATA, STOP, ERROR
    reg [7:0] data; // Data register
    reg [2:0] counter; // Bit counter

    // Define the states
    localparam IDLE = 3'b000;
    localparam START = 3'b001;
    localparam DATA = 3'b010;
    localparam STOP = 3'b011;
    localparam ERROR = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 3'b000;
            data <= 8'b00000000;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (~in) begin // Check for start bit
                        state <= START;
                    end
                end
                START: begin
                    state <= DATA;
                end
                DATA: begin
                    data <= {data[6:0], in}; // Shift in the new data bit
                    counter <= counter + 1'b1;
                    if (counter == 3'b100) begin // All 8 data bits received
                        state <= STOP;
                    end
                end
                STOP: begin
                    if (in) begin // Check for stop bit
                        done <= 1'b1; // Assert 'done' signal
                        state <= IDLE; // Go back to IDLE state
                    end else begin
                        state <= ERROR; // Go to ERROR state if stop bit is not 1
                    end
                end
                ERROR: begin
                    if (in) begin // Wait for a stop bit (1) before going back to IDLE
                        state <= IDLE;
                    end
                end
            endcase
            if (state == IDLE) begin // De-assert 'done' signal when in IDLE state
                done <= 1'b0;
            end
        end
    end

endmodule