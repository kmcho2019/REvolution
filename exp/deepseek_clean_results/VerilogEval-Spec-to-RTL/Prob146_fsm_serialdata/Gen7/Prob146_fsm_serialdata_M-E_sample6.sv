module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // FSM states
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam WAIT_STOP = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_ptr;  // Circular buffer pointer
    reg [7:0] data_buf;  // Circular buffer for data bits
    reg valid_stop;     // Combinatorial stop bit detection

    // Combinatorial done signal
    assign done = (state == WAIT_STOP) && valid_stop;

    // Stop bit detection
    assign valid_stop = in;

    // State transition and data capture
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_ptr <= 3'b0;
            data_buf <= 8'b0;
            out_byte <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (~in) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_ptr <= 3'b0;
                    end
                end

                RECEIVE: begin
                    // Store current bit at pointer location
                    data_buf[bit_ptr] <= in;
                    
                    if (bit_ptr == 3'b111) begin  // All bits received
                        state <= WAIT_STOP;
                    end else begin
                        bit_ptr <= bit_ptr + 1;
                    end
                end

                WAIT_STOP: begin
                    if (valid_stop) begin
                        out_byte <= data_buf;  // Parallel output capture
                        state <= IDLE;
                    end
                    // Stay in this state until stop bit found
                end
            endcase
        end
    end

endmodule