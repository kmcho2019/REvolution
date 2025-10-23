module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [3:0];  // stack memory to store data
reg [1:0] SP;              // stack pointer to track current position
reg [3:0] temp_data;       // temporary data for output

assign EMPTY = (SP == 4);   // flag for empty buffer
assign FULL = (SP == 0);    // flag for full buffer

always @(posedge Clk) begin
    if (Rst) begin         // reset signal is high
        SP <= 4;            // set stack pointer to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // clear all memory locations
        end
    end else if (EN) begin  // enable signal is high
        if (~RW) begin      // write operation (RW is low)
            if (~FULL) begin // buffer is not full
                stack_mem[SP - 1] <= dataIn; // push data onto stack
                SP <= SP - 1;                // decrement stack pointer
            end
        end else begin      // read operation (RW is high)
            if (~EMPTY) begin // buffer is not empty
                temp_data <= stack_mem[SP]; // pop data from stack
                stack_mem[SP] <= 4'b0;      // clear popped memory location
                SP <= SP + 1;               // increment stack pointer
            end
        end
    end
end

assign dataOut = temp_data; // assign output data

endmodule