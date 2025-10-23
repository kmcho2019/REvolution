module LIFObuffer(
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,          // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];   // 4 entries x 4 bits
    reg [2:0] SP;                // stack pointer: 0 to 4 entries

    // Flags combinationally derived
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

    integer i;
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'b0;
            // Clear stack memory for clarity
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // No dataOut update on push
            end else begin
                // Read (pop) operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    stack_mem[SP - 1] <= 4'b0; // Optional clear
                end else begin
                    dataOut <= 4'b0;
                end
            end
        end
    end

endmodule