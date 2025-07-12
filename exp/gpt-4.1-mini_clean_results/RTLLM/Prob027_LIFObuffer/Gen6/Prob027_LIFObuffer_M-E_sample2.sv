module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,       // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [0:3];  // 4-entry memory array (4-bit each)
    reg [2:0] SP;               // Stack pointer: number of valid entries (0 to 4)

    integer i;

    // Flags combinationally assigned
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Clear entire stack memory
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1'b1;
                    // dataOut unchanged on push
                end
                // if full, no operation, dataOut unchanged
            end else begin
                // Pop operation
                if (SP > 3'd0) begin
                    SP <= SP - 1'b1;
                    dataOut <= stack_mem[SP - 1];
                    stack_mem[SP - 1] <= 4'd0;
                end else begin
                    // Empty buffer pop attempt, dataOut cleared
                    dataOut <= 4'd0;
                end
            end
        end
    end

endmodule