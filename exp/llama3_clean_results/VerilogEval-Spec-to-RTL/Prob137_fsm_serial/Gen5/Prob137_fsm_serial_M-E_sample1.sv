module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data; // 8-bit shift register to collect incoming data bits
reg [2:0] bit_count; // 3-bit counter to keep track of number of bits received
reg [1:0] state; // 2-bit FSM state register

// Define the FSM states
localparam IDLE = 2'b00;
localparam RECEIVE = 2'b01;
localparam WAIT_STOP = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        data <= 8'b0; // Reset data register
        bit_count <= 3'b0; // Reset counter
        state <= IDLE; // Reset FSM state
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    state <= RECEIVE; // Transition to RECEIVE state
                    bit_count <= 3'b1; // Increment counter
                    data <= {7'b0, in}; // Load start bit into data register (not used)
                end
            end
            RECEIVE: begin
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 8) begin // 8 data bits received
                    state <= WAIT_STOP; // Transition to WAIT_STOP state
                end
            end
            WAIT_STOP: begin
                if (in) begin // Stop bit detected
                    done <= 1'b1; // Set done signal high
                    state <= IDLE; // Transition back to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule