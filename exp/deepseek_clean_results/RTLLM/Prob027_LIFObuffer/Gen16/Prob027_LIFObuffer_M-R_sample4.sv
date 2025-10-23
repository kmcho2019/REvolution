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
    // State encoding: 
    // 000 = empty, 001 = 1 entry, 010 = 2 entries, 011 = 3 entries, 100 = full
    reg [2:0] state;

    // Flag assignments
    assign EMPTY = (state == 3'b000);
    assign FULL = (state == 3'b100);

    // Stack memory updates (combinational)
    always @(posedge Clk) begin
        if (Rst) begin
            state <= 3'b000;
        end
        else if (EN) begin
            // Push operation
            if (!RW && !FULL) begin
                stack_mem[state[1:0]] <= dataIn;
                state <= state + 1;
            end
            // Pop operation
            else if (RW && !EMPTY) begin
                state <= state - 1;
            end
        end
    end

    // Output logic (combinational)
    always @(*) begin
        if (EN && RW && !EMPTY) begin
            dataOut = stack_mem[state[1:0] - 1];
        end
        else begin
            dataOut = 4'b0;
        end
    end

endmodule