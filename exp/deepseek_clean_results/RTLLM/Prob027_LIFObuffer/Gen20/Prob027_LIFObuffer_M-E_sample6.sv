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

    // Gray-coded stack pointer (3 bits: 2 for position, 1 for wrap)
    reg [2:0] SP, SP_next;
    wire [2:0] SP_gray = SP ^ {1'b0, SP[2:1]};
    
    // Stack memory (4 entries)
    reg [3:0] stack_mem [0:3];
    
    // Predictive flags (combinational)
    wire will_be_full = (SP[1:0] == 2'b11) && !RW && EN;
    wire will_be_empty = (SP[1:0] == 2'b00) && RW && EN;
    
    assign FULL = (SP[1:0] == 2'b11) && !SP[2];
    assign EMPTY = (SP[1:0] == 2'b00) && SP[2];
    
    // Early output mux
    wire [3:0] next_dataOut = stack_mem[SP[1:0]];
    
    // Next pointer logic
    always @(*) begin
        SP_next = SP;
        if (Rst) begin
            SP_next = 3'b100; // Empty state (pointer at 0 with wrap bit set)
        end
        else if (EN) begin
            if (!RW && !FULL) begin // Push
                SP_next[1:0] = SP[1:0] + 1;
                if (SP[1:0] == 2'b11) SP_next[2] = 1'b0;
            end
            else if (RW && !EMPTY) begin // Pop
                SP_next[1:0] = SP[1:0] - 1;
                if (SP[1:0] == 2'b00) SP_next[2] = 1'b1;
            end
        end
    end
    
    // Sequential logic
    always @(posedge Clk) begin
        SP <= SP_next;
        
        // Memory operations
        if (EN && !RW && !FULL) begin
            stack_mem[SP_next[1:0]] <= dataIn;
        end
        
        // Output register
        if (EN && RW && !EMPTY) begin
            dataOut <= next_dataOut;
        end
        else if (Rst) begin
            dataOut <= 4'b0;
        end
    end

endmodule