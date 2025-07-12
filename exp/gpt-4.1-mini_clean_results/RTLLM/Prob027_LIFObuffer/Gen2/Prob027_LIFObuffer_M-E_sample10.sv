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

    reg [15:0] stack_shiftreg; // 4 entries x 4 bits
    reg [2:0]  SP;             // Counts entries (0-4)

    // Flags combinationally from SP
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            stack_shiftreg <= 16'b0;
            dataOut <= 4'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP < 4) begin
                    // Shift left by 4 bits to make room at LSB
                    // Insert new data at LSB (bottom of stack)
                    stack_shiftreg <= {stack_shiftreg[11:0], dataIn};
                    SP <= SP + 1;
                end
                // No output change on push
            end else begin
                // Read (pop)
                if (SP > 0) begin
                    // Output LSB 4 bits (top of stack)
                    dataOut <= stack_shiftreg[3:0];
                    // Shift right by 4 bits to remove popped element
                    stack_shiftreg <= {4'b0, stack_shiftreg[15:4]};
                    SP <= SP - 1;
                end else begin
                    dataOut <= 4'b0;
                end
            end
        end
    end

endmodule