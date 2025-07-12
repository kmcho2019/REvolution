module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states for the finite state machine
localparam IDLE = 2'b00;
localparam RECV = 2'b01;
localparam STOP = 2'b10;

reg [1:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 3'b000;
        done <= 0;
        out_byte <= 8'b0;
    end else begin
        case(state)
            IDLE: begin
                if (!in) begin // Start bit detected
                    state <= RECV;
                    bit_counter <= 3'b000;
                    data <= 8'b0;
                end else if (in) begin // Potential stop bit, but not after a byte
                    state <= IDLE;
                    done <= 1; // Assert done on any stop bit
                end
            end
            RECV: begin
                data <= {data[6:0], in}; // Shift data bits to the left, adding new bit to the right
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd7) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Stop bit correctly received
                    state <= IDLE;
                    out_byte <= data; // Update out_byte with received data
                    done <= 1; // Assert done on stop bit after a byte
                end else begin // Incorrect stop bit, wait for correct stop
                    state <= STOP;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
        // Reset done signal
        if (state != STOP && done) begin
            done <= 0;
        end
    end
end

endmodule