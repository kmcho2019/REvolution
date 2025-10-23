module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Stack pointer (3 bits: 0=empty, 1-4=valid, 5-7=unused)
    reg [2:0] SP;

    // Combinational flag assignments
    assign EMPTY = (SP == 3'b000);
    assign FULL = (SP == 3'b100);

    // Stack pointer control logic
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'b000;  // Empty state
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                SP <= SP + 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                SP <= SP - 1;
            end
        end
    end

    // Memory and data output logic
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP[1:0]] <= dataIn;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP[1:0]-1];
            end
        end
    end

endmodule