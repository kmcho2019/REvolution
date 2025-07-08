module LIFObuffer(
    input wire [3:0] dataIn,
    input wire RW,      // 1 = read (pop), 0 = write (push)
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // 3 bits to represent 0 to 4 (stack pointer)

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset stack pointer and clear memory
                SP <= 3'd4;
                for (i=0; i<4; i=i+1) begin
                    stack_mem[i] <= 4'd0;
                end
                dataOut <= 4'd0;
            end else begin
                if (RW == 1'b0) begin
                    // Write operation (push)
                    if (SP != 0) begin
                        SP <= SP - 1'b1;
                        stack_mem[SP - 1'b1] <= dataIn;
                    end
                    // if full, ignore write
                end else begin
                    // Read operation (pop)
                    if (SP != 4) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'd0;
                        SP <= SP + 1'b1;
                    end else begin
                        dataOut <= 4'd0; // no data to pop when empty
                    end
                end
            end
        end
    end

    // Update flags asynchronously based on SP
    always @(*) begin
        EMPTY = (SP == 4);
        FULL  = (SP == 0);
    end

endmodule