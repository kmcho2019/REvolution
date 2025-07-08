module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,       // 0: write (push), 1: read (pop)
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // Stack pointer, ranges from 0 to 4 (3 bits enough)

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset stack
                SP <= 4;
                for (i=0; i<4; i=i+1)
                    stack_mem[i] <= 4'b0000;
                dataOut <= 4'b0000;
                EMPTY <= 1;
                FULL <= 0;
            end else begin
                // Normal operation
                if (RW == 0) begin
                    // Write (push) operation
                    if (SP > 0) begin
                        SP <= SP - 1;
                        stack_mem[SP - 1] <= dataIn; // Write before decrement for proper indexing
                    end
                end else begin
                    // Read (pop) operation
                    if (SP < 4) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'b0000;
                        SP <= SP + 1;
                    end else begin
                        dataOut <= 4'b0000;
                    end
                end

                // Update flags
                EMPTY <= (SP == 4);
                FULL <= (SP == 0);
            end
        end
    end

endmodule