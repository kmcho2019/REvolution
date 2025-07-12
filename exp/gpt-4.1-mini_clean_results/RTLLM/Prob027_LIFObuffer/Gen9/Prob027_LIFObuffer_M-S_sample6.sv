module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,     // active high reset
    input  wire       EN,      // enable
    input  wire       RW,      // 0 = write (push), 1 = read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries x 4 bits
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: points to next free position, 0..4 valid (max 4)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else full, do nothing
            end else begin
                // Read (pop)
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                end
                // else empty, dataOut unchanged
            end
        end
    end

    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

endmodule