module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0]; // 4 entries of 4-bit width
    reg [2:0] SP; // Stack Pointer: values 0 to 4 (3 bits to hold value 4)

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset: clear stack memory and set SP to 4 (empty)
                SP <= 3'd4;
                dataOut <= 4'b0;
                for (i = 0; i < 4; i = i + 1) begin
                    stack_mem[i] <= 4'b0;
                end
            end else begin
                // Normal operation
                if (RW == 1'b0) begin
                    // Write operation (push)
                    if (SP > 0) begin
                        SP <= SP - 1;
                        stack_mem[SP - 1] <= dataIn;
                    end
                    dataOut <= 4'b0;
                end else begin
                    // Read operation (pop)
                    if (SP < 4) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'b0;
                        SP <= SP + 1;
                    end else begin
                        dataOut <= 4'b0;
                    end
                end
            end
        end else begin
            // If not enabled, hold outputs and SP
            dataOut <= dataOut;
            SP <= SP;
        end
    end

    // Update EMPTY and FULL flags combinationally from SP
    always @(*) begin
        EMPTY = (SP == 3'd4);
        FULL  = (SP == 3'd0);
    end

endmodule