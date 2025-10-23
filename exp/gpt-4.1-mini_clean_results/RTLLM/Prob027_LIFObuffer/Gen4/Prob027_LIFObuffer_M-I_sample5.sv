module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write(push), 1: read(pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: 0 to 4, number of items in stack

    integer i;

    // Synchronous reset and push/pop logic
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;      // Empty stack pointer
            dataOut <= 4'd0;
            // Initialize stack_mem asynchronously or rely on synthesis default init
            // but do a simple clear here to avoid tool ambiguity
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push): if not full, store data and increment SP
                if (SP != 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else full: no operation
            end else begin
                // Read (pop): if not empty, decrement SP and output data
                if (SP != 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // No clearing stack_mem to save toggling
                end
                // else empty: no operation, dataOut unchanged
            end
        end
    end

    // Combinational flags
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

endmodule