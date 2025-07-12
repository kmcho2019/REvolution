module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [7:0] data; // Register to hold the received data
reg [2:0] state; // State register (3 states: idle, start_bit, data, error)
reg done_reg; // Register for done signal

// Define states
parameter IDLE = 3'b000;
parameter START_BIT = 3'b001;
parameter DATA = 3'b010;
parameter STOP_BIT = 3'b011;
parameter ERROR = 3'b100;

// Counter for data bits
reg [2:0] bit_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 0;
        bit_counter <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (!in) begin // Start bit detected
                    state <= START_BIT;
                end else begin
                    state <= IDLE;
                end
            end
            START_BIT: begin
                state <= DATA;
            end
            DATA: begin
                // Shift in the data bit
                data <= {data[6:0], in};
                if (bit_counter == 7) begin
                    state <= STOP_BIT;
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end
            STOP_BIT: begin
                if (in) begin // Stop bit detected, byte received correctly
                    done_reg <= 1;
                    state <= IDLE;
                    bit_counter <= 0;
                end else begin // Stop bit not detected, go to error state
                    state <= ERROR;
                end
            end
            ERROR: begin
                if (in) begin // Stop bit detected, transition back to idle
                    state <= IDLE;
                    bit_counter <= 0;
                end else begin
                    state <= ERROR;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

// Set done output
always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end else if (done_reg) begin
        done <= 1;
        done_reg <= 0;
    end else begin
        done <= 0;
    end
end

endmodule