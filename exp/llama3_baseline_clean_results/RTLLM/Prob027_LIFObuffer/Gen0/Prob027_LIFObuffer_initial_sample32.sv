module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [3:0]; // stack memory array
reg [1:0] SP; // stack pointer

always @(posedge Clk) begin
    if (Rst) begin // reset
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // clear stack memory
        end
        SP <= 4'd4; // set stack pointer to 4 (indicating an empty buffer)
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin // enable signal is high
        if (!RW && SP > 4'd0 && !FULL) begin // push operation
            stack_mem[SP - 1] <= dataIn; // push data onto the stack
            SP <= SP - 1; // decrement stack pointer
            if (SP == 4'd0) begin
                FULL <= 1'b1; // set FULL flag
            end
            EMPTY <= 1'b0; // clear EMPTY flag
        end else if (RW && SP < 4'd4 && !EMPTY) begin // pop operation
            dataOut <= stack_mem[SP]; // pop data from the stack
            stack_mem[SP] <= 4'd0; // clear the corresponding stack memory
            SP <= SP + 1; // increment stack pointer
            if (SP == 4'd4) begin
                EMPTY <= 1'b1; // set EMPTY flag
            end
            FULL <= 1'b0; // clear FULL flag
        end
    end
end

always @(*) begin
    if (SP == 4'd0) begin
        FULL <= 1'b1;
    end else begin
        FULL <= 1'b0;
    end
    if (SP == 4'd4) begin
        EMPTY <= 1'b1;
    end else begin
        EMPTY <= 1'b0;
    end
end

endmodule