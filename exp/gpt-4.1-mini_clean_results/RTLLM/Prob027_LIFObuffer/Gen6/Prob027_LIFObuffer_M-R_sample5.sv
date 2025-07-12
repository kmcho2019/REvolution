module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: points to next free slot, 0=empty, 4=full

    integer i;

    // Synchronous reset and push operation
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'b0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'b0;
        end else if (EN && (RW == 1'b0)) begin // Write (push)
            if (SP < 3'd4) begin
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
        end
    end

    // Pop operation and dataOut update
    always @(posedge Clk) begin
        if (Rst) begin
            // dataOut cleared in previous always block
        end else if (EN && (RW == 1'b1)) begin // Read (pop)
            if (SP > 3'd0) begin
                SP <= SP - 1;
                dataOut <= stack_mem[SP - 1];
                stack_mem[SP - 1] <= 4'b0; // Clear popped location
            end
        end
    end

    // Combinational flags update
    always @(*) begin
        EMPTY = (SP == 3'd0);
        FULL  = (SP == 3'd4);
    end

endmodule