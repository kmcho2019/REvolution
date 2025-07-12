module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory and pointer
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 0 to 4, 4 means empty

    integer i;

    // Assign flags directly from SP (no extra registers)
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // Empty stack pointer
            dataOut <= 4'd0;
            // Clear stack memory
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP != 3'd0) begin
                    // Push data into stack at SP-1
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                end
                // else buffer full: no operation
            end else begin
                // Read (pop)
                if (SP != 3'd4) begin
                    // Output top stack data, then increment SP
                    dataOut <= stack_mem[SP];
                    SP <= SP + 1;
                    // No need to clear stack_mem
                end
                // else buffer empty: dataOut retains value
            end
        end
        // else EN=0: hold values, no change
    end

endmodule