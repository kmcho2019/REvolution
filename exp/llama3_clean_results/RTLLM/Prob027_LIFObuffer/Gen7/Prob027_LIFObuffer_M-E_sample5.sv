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

reg [3:0] shift_reg; // 4-bit shift register
reg [3:0] circ_buf[3:0]; // 4x4-bit circular buffer
reg [1:0] ptr; // 2-bit pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear shift register, circular buffer, and pointer
        shift_reg <= 4'd0;
        for (int i = 0; i < 4; i++) begin
            circ_buf[i] <= 4'd0;
        end
        ptr <= 2'd0;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'd0;
    end else if (EN) begin
        if (~RW) begin
            // Write operation: Shift data into circular buffer
            if (ptr == 2'd3) begin
                // Wrap around to the beginning of the buffer
                ptr <= 2'd0;
            end else begin
                ptr <= ptr + 1;
            end
            circ_buf[ptr] <= dataIn;
            FULL <= (ptr == 2'd3);
            EMPTY <= 1'b0;
        end else begin
            // Read operation: Shift data out of circular buffer
            if (ptr == 2'd0) begin
                // Wrap around to the end of the buffer
                ptr <= 2'd3;
            end else begin
                ptr <= ptr - 1;
            end
            dataOut <= circ_buf[ptr];
            circ_buf[ptr] <= 4'd0;
            EMPTY <= (ptr == 2'd0);
            FULL <= 1'b0;
        end
    end
end

endmodule