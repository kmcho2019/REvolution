module LIFObuffer(
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,       // 0 = write (push), 1 = read (pop)
    input  wire [3:0] dataIn,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 3-bit to hold values 0 to 4

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset: clear stack and set SP to 4 (empty)
                SP <= 3'd4;
                dataOut <= 4'b0;
                EMPTY <= 1'b1;
                FULL <= 1'b0;
                for (i = 0; i < 4; i = i +1) begin
                    stack_mem[i] <= 4'b0;
                end
            end else begin
                // Normal operation
                if (RW == 1'b0) begin
                    // Write (push) if not full
                    if (SP > 0) begin
                        SP <= SP - 1;
                        stack_mem[SP - 1] <= dataIn;
                    end
                    // else do nothing if full
                end else begin
                    // Read (pop) if not empty
                    if (SP < 4) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'b0;
                        SP <= SP + 1;
                    end else begin
                        dataOut <= 4'b0; // no valid pop, output zero
                    end
                end

                // Update flags
                EMPTY <= (SP == 4);
                FULL  <= (SP == 0);
            end
        end
    end

endmodule