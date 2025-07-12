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
    reg [2:0] SP; // 3 bits to represent 0 to 4

    integer i;

    // Sequential logic: push/pop and reset
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;        // Empty stack pointer at 4
            dataOut <= 4'b0000;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'b0000;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation: push data if not full
                if (SP != 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    // dataOut unchanged
                end
                // else full: no operation
            end else begin
                // Read (pop) operation: pop data if not empty
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    // Do not clear stack_mem on pop to save switching
                    SP <= SP + 1;
                end
                // else empty: no operation, dataOut unchanged
            end
        end
    end

    // Combinational logic: generate EMPTY and FULL flags based on SP
    assign EMPTY = (SP == 4);
    assign FULL  = (SP == 0);

endmodule