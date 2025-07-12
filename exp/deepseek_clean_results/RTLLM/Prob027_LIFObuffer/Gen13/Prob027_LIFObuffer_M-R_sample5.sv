module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output wire [3:0] dataOut
);

    // Internal stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (2 bits to cover 0-3)
    reg [1:0] SP;
    reg [3:0] out_reg;

    // Combinational assignments
    assign EMPTY = (SP == 2'b00);
    assign FULL = (SP == 2'b11);
    assign dataOut = out_reg;

    // Stack pointer control
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'b00;
        end
        else if (EN) begin
            if (!RW && !FULL) begin  // Push operation
                SP <= SP + 1;
            end
            else if (RW && !EMPTY) begin  // Pop operation
                SP <= SP - 1;
            end
        end
    end

    // Memory write operations
    always @(posedge Clk) begin
        if (EN && !RW && !FULL) begin
            stack_mem[SP] <= dataIn;
        end
    end

    // Output register
    always @(posedge Clk) begin
        if (Rst) begin
            out_reg <= 4'b0;
        end
        else if (EN && RW && !EMPTY) begin
            out_reg <= stack_mem[SP-1];
        end
    end

endmodule