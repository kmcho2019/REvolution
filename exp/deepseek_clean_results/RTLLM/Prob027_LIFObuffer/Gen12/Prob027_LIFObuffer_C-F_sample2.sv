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
    
    // Stack pointer (2 bits) with empty state detection
    reg [1:0] SP;
    reg empty_state;

    // Combinational flag assignments
    assign EMPTY = empty_state;
    assign FULL = (!empty_state && (SP == 2'b11));

    // Stack pointer control logic
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'b00;
            empty_state <= 1'b1;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                if (empty_state) begin
                    empty_state <= 1'b0;
                end
                else begin
                    SP <= SP + 1;
                end
            end
            else if (RW && !EMPTY) begin
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

    // Memory and data output logic
    always @(posedge Clk) begin
        if (Rst) begin
            // Initialize only used memory locations
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[empty_state ? 0 : SP + 1] <= dataIn;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
            end
        end
    end

endmodule