module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: 0 to 4
    // SP points to next free slot:
    // SP == 0 means empty (no data)
    // SP == 4 means full (all slots occupied)
    reg [2:0] SP;

    integer i;

    // Temporary variables for memory indexing and next SP value
    reg [2:0] next_SP;
    reg [1:0] mem_index;

    // Flags combinationally derived from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation: only if not full
                if (SP != 3'd4) begin
                    // Write dataIn to current SP location, then increment SP
                    mem_index = SP[1:0];
                    stack_mem[mem_index] <= dataIn;
                    next_SP = SP + 1;
                    SP <= next_SP;
                end
                // else full: no operation
            end else begin
                // Read (pop) operation: only if not empty
                if (SP != 3'd0) begin
                    // Decrement SP then read data at new SP location
                    next_SP = SP - 1;
                    mem_index = next_SP[1:0];
                    dataOut <= stack_mem[mem_index];
                    SP <= next_SP;
                    // Do NOT clear memory on pop to reduce switching
                end
                // else empty: no operation, dataOut unchanged
            end
        end
        // else EN=0: no operation
    end

endmodule