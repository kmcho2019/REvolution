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

    // Stack memory (4 entries, each 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Binary-encoded stack pointer (2 bits)
    reg [1:0] SP;
    reg empty_flag;

    // Operation control signals
    wire do_push = EN && !RW && !FULL;
    wire do_pop  = EN && RW && !EMPTY;

    // Combinational flag logic
    assign EMPTY = empty_flag;
    assign FULL = (!empty_flag && (SP == 2'b11));

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 2'b00;
            empty_flag <= 1'b1;
            dataOut <= 4'b0;
            // Only clear first location (others will be overwritten)
            stack_mem[0] <= 4'b0;
        end
        else begin
            if (do_push) begin
                if (empty_flag) begin
                    // First push after empty
                    stack_mem[0] <= dataIn;
                    empty_flag <= 1'b0;
                end
                else begin
                    // Subsequent pushes
                    stack_mem[SP + 1] <= dataIn;
                    SP <= SP + 1;
                end
            end
            else if (do_pop) begin
                dataOut <= stack_mem[SP];
                if (SP == 2'b00) begin
                    // Last pop
                    empty_flag <= 1'b1;
                end
                else begin
                    SP <= SP - 1;
                end
            end
        end
    end

endmodule