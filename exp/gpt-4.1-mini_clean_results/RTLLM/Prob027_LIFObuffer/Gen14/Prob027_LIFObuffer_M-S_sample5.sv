module LIFObuffer(
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [0:3];
    reg [2:0] SP; // Stack pointer: 4 means empty, 0 means full

    integer i;

    // Flags combinationally from SP
    assign EMPTY = (SP == 4);
    assign FULL  = (SP == 0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 4;
            dataOut <= 4'b0;
            for (i = 0; i < 4; i = i +1) begin
                stack_mem[i] <= 4'b0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP > 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    // No output change on push
                end
            end else begin
                // Read (pop)
                if (SP < 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;
                    SP <= SP + 1;
                end else begin
                    dataOut <= 4'b0;
                end
            end
        end
    end

endmodule