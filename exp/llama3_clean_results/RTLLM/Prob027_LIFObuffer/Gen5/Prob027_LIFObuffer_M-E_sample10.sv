module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal to activate buffer operations
    input Rst,           // Active high reset signal to initialize the buffer
    input Clk,           // Clock signal for synchronous operations
    output reg EMPTY,    // Flag indicating whether the buffer is empty
    output reg FULL,     // Flag indicating whether the buffer is full
    output reg [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] fifo_buffer[3:0]; // FIFO buffer to store data
reg [1:0] fifo_ptr;        // Pointer for the FIFO buffer
reg [1:0] state;           // State machine state

// State machine states
parameter IDLE = 2'd0;
parameter PUSH = 2'd1;
parameter POP = 2'd2;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear FIFO buffer, set pointer to 0, and reset state machine
        for (int i = 0; i < 4; i++) begin
            fifo_buffer[i] <= 4'd0;
        end
        fifo_ptr <= 2'd0;
        state <= IDLE;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'd0;
    end else if (EN) begin
        case (state)
            IDLE: begin
                if (~RW) begin
                    // Push data into the FIFO buffer
                    if (fifo_ptr < 4) begin
                        fifo_buffer[fifo_ptr] <= dataIn;
                        fifo_ptr <= fifo_ptr + 1;
                        state <= PUSH;
                    end
                end else if (RW) begin
                    // Pop data from the FIFO buffer
                    if (fifo_ptr > 0) begin
                        dataOut <= fifo_buffer[fifo_ptr - 1];
                        fifo_buffer[fifo_ptr - 1] <= 4'd0;
                        fifo_ptr <= fifo_ptr - 1;
                        state <= POP;
                    end
                end
            end
            PUSH: begin
                // Update EMPTY and FULL flags
                EMPTY <= (fifo_ptr == 0);
                FULL <= (fifo_ptr == 4);
                state <= IDLE;
            end
            POP: begin
                // Update EMPTY and FULL flags
                EMPTY <= (fifo_ptr == 0);
                FULL <= (fifo_ptr == 4);
                state <= IDLE;
            end
        endcase
    end
end

endmodule