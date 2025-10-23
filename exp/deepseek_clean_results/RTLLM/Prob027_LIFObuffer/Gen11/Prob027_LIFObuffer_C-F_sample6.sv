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
    // Stack pointer (2 bits) with empty state
    reg [1:0] SP;
    reg empty_state;
    
    // Operation validation signal
    wire op_valid = EN && ((!RW && !FULL) || (RW && !EMPTY));
    
    // Combinational flag assignments
    assign EMPTY = empty_state;
    assign FULL = (!empty_state && (SP == 2'b11));

    // Control logic: Stack pointer and empty state
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'b00;
            empty_state <= 1'b1;
        end
        else if (op_valid) begin
            if (!RW) begin
                // Write operation (push)
                if (empty_state) begin
                    empty_state <= 1'b0;
                end
                else begin
                    SP <= SP + 1;
                end
            end
            else begin
                // Read operation (pop)
                if (SP == 2'b00) begin
                    empty_state <= 1'b1;
                end
                else begin
                    SP <= SP - 1;
                end
            end
        end
    end

    // Data path: Memory and output
    always @(posedge Clk) begin
        if (Rst) begin
            // Initialize only first location (others will be overwritten)
            stack_mem[0] <= 4'b0;
            dataOut <= 4'b0;
        end
        else if (op_valid) begin
            if (!RW) begin
                // Write operation (push)
                stack_mem[empty_state ? 0 : SP + 1] <= dataIn;
            end
            else begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
            end
        end
    end

endmodule