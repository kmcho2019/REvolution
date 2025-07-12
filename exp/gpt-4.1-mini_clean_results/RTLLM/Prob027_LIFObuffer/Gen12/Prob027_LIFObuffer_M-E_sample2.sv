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

    reg [3:0] stack_mem [0:3];  // 4-entry stack memory, each 4 bits
    reg [2:0] SP;               // Stack pointer: counts entries (0 to 4)

    integer i;

    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'b0;
            // Clear stack memory
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // No change to dataOut on push
            end else begin
                // Read (pop) operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // Optional: clear popped element for cleanliness
                    stack_mem[SP - 1] <= 4'b0;
                end else begin
                    dataOut <= 4'b0; // Empty output if pop when empty
                end
            end
        end
    end

endmodule