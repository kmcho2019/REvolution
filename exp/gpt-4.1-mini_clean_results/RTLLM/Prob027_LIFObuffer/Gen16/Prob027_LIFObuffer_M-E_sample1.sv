module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,       // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg         EMPTY,
    output reg         FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [0:3];  // 4x4-bit stack memory
    reg [2:0] SP;               // Stack pointer: counts items in stack (0=empty, 4=full)
    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write / Push operation
                if (SP < 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 3'd1;
                end
                // Update flags after possible push
                EMPTY <= (SP + 3'd1 == 3'd0) ? 1'b1 : 1'b0; // will never be 0 after push
                FULL <= (SP + 3'd1 == 3'd4) ? 1'b1 : 1'b0;
            end else begin
                // Read / Pop operation
                if (SP > 3'd0) begin
                    SP <= SP - 3'd1;
                    dataOut <= stack_mem[SP - 3'd1];
                end
                // Update flags after possible pop
                EMPTY <= (SP - 3'd1 == 3'd0) ? 1'b1 : 1'b0;
                FULL <= (SP - 3'd1 == 3'd4) ? 1'b1 : 1'b0; // cannot be full after pop
            end
        end else begin
            // If EN is low, flags and outputs remain unchanged
            // (Alternatively, flags can be combinational but here kept synchronous)
        end
    end

endmodule