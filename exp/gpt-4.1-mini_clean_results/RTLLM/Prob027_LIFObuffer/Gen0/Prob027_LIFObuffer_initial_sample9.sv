module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,    // 0: write(push), 1: read(pop)
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 3 bits enough to count 0 to 4

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset buffer
            SP <= 3'd4;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP != 3'd0) begin
                    SP <= SP - 1'b1;
                    stack_mem[SP - 1] <= dataIn; // SP after decrement points to new top
                    EMPTY <= 1'b0;
                    FULL <= (SP - 1 == 3'd0) ? 1'b1 : 1'b0;
                end
                // If full, no operation on push
            end else begin
                // Read operation (pop)
                if (SP != 3'd4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1'b1;
                    EMPTY <= (SP + 1 == 3'd4) ? 1'b1 : 1'b0;
                    FULL <= 1'b0;
                end else begin
                    // Buffer empty, output remains same
                    dataOut <= dataOut;
                    EMPTY <= 1'b1;
                    FULL <= 1'b0;
                end
            end
        end
    end

endmodule