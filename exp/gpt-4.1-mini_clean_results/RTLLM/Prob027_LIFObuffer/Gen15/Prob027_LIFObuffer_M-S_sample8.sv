module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,      // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Points to next free position (0 to 4)

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
            end else begin
                // Pop operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    stack_mem[SP - 1] <= 4'b0; // Clear popped location
                end
            end
        end
    end

    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

endmodule