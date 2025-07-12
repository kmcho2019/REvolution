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

    reg [3:0] stack_mem [0:3]; // stack memory array
    reg [1:0] SP; // stack pointer (2 bits to represent 4 locations)
    reg [3:0] temp_data; // temporary data for output

    assign EMPTY = (SP == 4'b1111); // buffer is empty when SP is at 4
    assign FULL = (SP == 4'b0000); // buffer is full when SP is at 0

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear stack, set SP to 4, and initialize all memory locations to 0
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0000;
            end
            SP <= 2'b11; // 4 in decimal
        end
        else if (EN) begin
            if (~RW && ~FULL) begin
                // Write operation: push data onto the stack and decrement SP
                stack_mem[SP] <= dataIn;
                SP <= SP - 1'b1;
            end
            else if (RW && ~EMPTY) begin
                // Read operation: pop data from the stack into dataOut and increment SP
                temp_data <= stack_mem[SP + 1'b1];
                stack_mem[SP + 1'b1] <= 4'b0000; // clear the popped location
                SP <= SP + 1'b1;
            end
        end
    end

    always @(posedge Clk) begin
        if (~EMPTY) begin
            dataOut <= temp_data; // update dataOut only when buffer is not empty
        end
        else begin
            dataOut <= 4'b0000; // clear dataOut when buffer is empty
        end
    end

endmodule