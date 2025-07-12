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

    // Internal stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (2 bits to cover 0-3, plus empty state detection)
    reg [1:0] SP;
    reg empty_state;  // Additional bit to detect empty state (SP=4 equivalent)

    // Combinational flag assignments
    assign EMPTY = empty_state;
    assign FULL = (!empty_state && (SP == 2'b11));

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 2'b00;
            empty_state <= 1'b1;
            dataOut <= 4'b0;
            // Clear stack memory
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
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