module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // Stack memory array to store data
reg [1:0] SP; // Stack pointer to track current position

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and initialize the stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'b100; // 4 in binary, indicating an empty buffer
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (!RW && (SP != 2'b000)) begin
            // Write operation: push data onto the stack
            stack_mem[SP] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW && (SP != 2'b100)) begin
            // Read operation: pop data from the stack
            dataOut <= stack_mem[SP + 1'b1];
            stack_mem[SP + 1'b1] <= 4'b0;
            SP <= SP + 1'b1;
        end
        // Update flags based on stack pointer status
        if (SP == 2'b100) begin
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (SP == 2'b000) begin
            EMPTY <= 1'b0;
            FULL <= 1'b1;
        end else begin
            EMPTY <= 1'b0;
            FULL <= 1'b0;
        end
    end
end

endmodule