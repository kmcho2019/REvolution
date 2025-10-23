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

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // State tracking
    reg [1:0] SP;  // Stack pointer (points to next free slot)
    reg empty_state;

    // Combinational outputs
    assign EMPTY = empty_state;
    assign FULL = (!empty_state && (SP == 2'b11)); // Direct comparison
    assign dataOut = stack_mem[empty_state ? 0 : SP]; // Safe access with empty check

    // Stack control
    always @(posedge Clk) begin
        if (Rst) begin
            // Optimized reset - only clear what's needed
            SP <= 2'b00;
            empty_state <= 1'b1;
            stack_mem[0] <= 4'b0; // Only clear first location
        end
        else if (EN) begin
            if (!empty_state && RW) begin
                // Read operation (pop)
                if (SP == 2'b00) begin
                    empty_state <= 1'b1;
                end
                else begin
                    SP <= SP - 1;
                end
            end
            else if (!FULL && !RW) begin
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
        end
    end

endmodule