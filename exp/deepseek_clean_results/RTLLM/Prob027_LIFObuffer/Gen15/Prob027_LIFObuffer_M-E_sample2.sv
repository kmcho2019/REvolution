module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Circular stack memory (4 entries)
    reg [3:0] stack_mem [0:3];
    
    // Unified pointer with direction (MSB indicates direction)
    reg [2:0] ptr;  // [2] = direction (0: decreasing, 1: increasing), [1:0] = position
    
    // Operation history tracking
    reg last_op_was_write;
    
    // Dynamic flag calculation
    assign EMPTY = (ptr[1:0] == 2'b00) && !ptr[2];
    assign FULL = (ptr[1:0] == 2'b11) && ptr[2];
    
    // Rising edge - handle writes
    always @(posedge Clk) begin
        if (Rst) begin
            ptr <= 3'b000;  // Pointer at 0, direction decreasing
            last_op_was_write <= 0;
            stack_mem[0] <= 0;
            stack_mem[1] <= 0;
            stack_mem[2] <= 0;
            stack_mem[3] <= 0;
        end
        else if (EN && !RW && !FULL) begin
            // Write operation on rising edge
            stack_mem[ptr[1:0]] <= dataIn;
            ptr <= {1'b1, ptr[1:0] + 1};  // Switch to increasing direction
            last_op_was_write <= 1;
        end
    end
    
    // Falling edge - handle reads
    always @(negedge Clk) begin
        if (Rst) begin
            dataOut <= 0;
        end
        else if (EN && RW && !EMPTY) begin
            // Read operation on falling edge
            dataOut <= stack_mem[ptr[1:0] - (ptr[2] ? 1 : 0)];
            ptr <= {1'b0, ptr[1:0] - 1};  // Switch to decreasing direction
            last_op_was_write <= 0;
        end
    end
    
    // Pointer wrap-around protection
    always @(ptr) begin
        if (ptr[1:0] == 2'b11 && ptr[2]) ptr[1:0] = 2'b00;  // Wrap around
        if (ptr[1:0] == 2'b00 && !ptr[2]) ptr[1:0] = 2'b11;  // Wrap around
    end

endmodule