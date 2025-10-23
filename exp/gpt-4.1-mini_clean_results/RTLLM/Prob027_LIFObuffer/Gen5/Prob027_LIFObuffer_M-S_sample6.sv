module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    localparam DEPTH = 4;
    localparam PTR_WIDTH = 2; // Enough for 0 to 4 (0..3 + full)

    reg [3:0] stack_mem [0:DEPTH-1];
    reg [PTR_WIDTH:0] SP; // Points to next free location (0 = empty, 4 = full)

    integer i;

    assign EMPTY = (SP == 0);
    assign FULL  = (SP == DEPTH);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'd0;
            for (i = 0; i < DEPTH; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < DEPTH) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
            end else begin
                // Pop operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    stack_mem[SP - 1] <= 4'd0;
                end
            end
        end
    end

endmodule