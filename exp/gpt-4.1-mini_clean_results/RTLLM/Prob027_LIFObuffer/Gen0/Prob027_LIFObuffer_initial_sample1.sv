module LIFObuffer(
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // Stack pointer, range 0 to 4 (3 bits)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear memory, set SP to 4 (empty)
            SP <= 3'd4;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP != 3'd0) begin
                    // Not full, so decrement SP and write data
                    SP <= SP - 1'b1;
                    stack_mem[SP - 1] <= dataIn;
                    dataOut <= 4'd0;
                end
                // else do nothing if full
            end else begin
                // Read operation (pop)
                if (SP != 3'd4) begin
                    // Not empty, output data and clear memory
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1'b1;
                end else begin
                    // Empty, no data
                    dataOut <= 4'd0;
                end
            end

            // Update flags after operation
            EMPTY <= (SP == 3'd4);
            FULL  <= (SP == 3'd0);
        end
    end

endmodule