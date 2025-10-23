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

    // Stack memory (4 entries of 4 bits)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (2 bits for 0-3)
    reg [1:0] SP;
    reg empty_state;  // Additional empty state flag

    // Combinational flag assignments
    assign EMPTY = empty_state;
    assign FULL = (!empty_state && (SP == 2'b11));  // SP at max when not empty

    always @(posedge Clk) begin
        if (Rst) begin
            // Minimal reset - only essential elements
            SP <= 2'b00;
            empty_state <= 1'b1;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                if (empty_state) begin
                    stack_mem[0] <= dataIn;
                    empty_state <= 1'b0;
                end
                else begin
                    stack_mem[SP + 1] <= dataIn;
                    SP <= SP + 1;
                end
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
                if (SP == 2'b00) begin
                    empty_state <= 1'b1;
                end
                else begin
                    SP <= SP - 1;
                end
            end
        end
    end

endmodule