module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // Points to next free slot (0 to 4)

    integer i;

    // Sequential logic: stack pointer and memory operations
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;            // Empty stack
            dataOut <= 4'b0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) if not full
                if (SP != 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else full: no operation
            end else begin
                // Read (pop) if not empty
                if (SP != 3'd0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                end
                // else empty: no operation, dataOut unchanged
            end
        end
    end

    // Combinational flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule