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
    reg [2:0] SP; // Stack pointer: points to next free slot, 0..4

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push
                if (SP != 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                end
            end else begin
                // Pop
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1;
                end
            end
        end
    end

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule