module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,       // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg         EMPTY,
    output reg         FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 3 bits enough to count 0 to 4

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack pointer and clear stack memory
            SP <= 3'd4;       // stack empty
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
        end else if (EN) begin
            // Push operation (write)
            if (!RW && (SP != 0)) begin
                SP <= SP - 1;
                stack_mem[SP - 1] <= dataIn;
                dataOut <= 4'd0; // dataOut undefined on push
            end
            // Pop operation (read)
            else if (RW && (SP != 4)) begin
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'd0;
                SP <= SP + 1;
            end else begin
                dataOut <= 4'd0; // No valid pop, output cleared
            end

            // Update flags after operation
            EMPTY <= (SP == 4);
            FULL  <= (SP == 0);
        end
    end

endmodule