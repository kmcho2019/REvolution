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
    
    // Stack pointer (3 bits: [2] is empty flag, [1:0] is position)
    reg [2:0] SP;

    // Combinational flag assignments
    assign EMPTY = SP[2];  // SP[2]=1 means empty
    assign FULL = (!SP[2] && (SP[1:0] == 2'b11));  // Full when SP points to last entry

    // Stack pointer control logic
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'b100;  // Set empty flag (SP[2]=1), position=00
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                if (SP[2]) begin
                    SP <= 3'b000;  // First write: clear empty flag, position=00
                end
                else begin
                    SP <= SP + 1;  // Increment position
                end
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                if (SP[1:0] == 2'b00) begin
                    SP <= 3'b100;  // Last read: set empty flag, position=00
                end
                else begin
                    SP <= SP - 1;  // Decrement position
                end
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
                stack_mem[SP[2] ? 0 : SP[1:0]] <= dataIn;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP[1:0]];
            end
        end
    end

endmodule