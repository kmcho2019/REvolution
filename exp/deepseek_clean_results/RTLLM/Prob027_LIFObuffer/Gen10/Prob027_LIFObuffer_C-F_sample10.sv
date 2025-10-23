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
    
    // Stack pointer (2 bits) + empty state detection
    reg [1:0] SP;
    reg empty_state;

    // Combinational flag assignments
    assign EMPTY = empty_state;
    assign FULL = (!empty_state && (&SP)); // SP == 2'b11

    always @(posedge Clk) begin
        if (Rst) begin
            // Optimized reset: only clear used memory locations
            SP <= 2'b00;
            empty_state <= 1'b1;
            dataOut <= 4'b0;
            // Only clear memory that will be used next
            stack_mem[0] <= 4'b0;
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

    // Initialize remaining memory locations (synthesis optimization)
    initial begin
        stack_mem[1] = 4'b0;
        stack_mem[2] = 4'b0;
        stack_mem[3] = 4'b0;
    end

endmodule