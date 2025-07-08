module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,       // 0 = write (push), 1 = read (pop)
    input  wire [3:0] dataIn,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];  // 4 entries of 4-bit width
    reg [2:0] SP;               // Stack pointer: values from 0 to 4 (3 bits to hold 0-4)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'b0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP > 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                end
                // else full - no operation
            end else begin
                // Read operation (pop)
                if (SP < 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;
                    SP <= SP + 1;
                end
                // else empty - no operation, dataOut unchanged
            end
            // Update flags after operation
            EMPTY <= (SP == 4);
            FULL  <= (SP == 0);
        end
    end

endmodule