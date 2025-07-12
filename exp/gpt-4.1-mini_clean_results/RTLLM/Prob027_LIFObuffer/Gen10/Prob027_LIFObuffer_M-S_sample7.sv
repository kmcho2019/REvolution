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

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // Stack Pointer: 4 = empty, 0 = full

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            // No clearing of stack_mem to reduce complexity
        end else if (EN) begin
            if (RW == 1'b0) begin // Write (push)
                if (SP != 3'd0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                end
            end else begin // Read (pop)
                if (SP != 3'd4) begin
                    dataOut <= stack_mem[SP];
                    SP <= SP + 1;
                end
            end
        end
    end

endmodule