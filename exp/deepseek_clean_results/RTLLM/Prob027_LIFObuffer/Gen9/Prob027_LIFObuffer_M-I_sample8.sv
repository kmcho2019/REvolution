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
    // Gray-coded stack pointer (2 bits)
    reg [1:0] SP_gray;
    
    // Gray to binary conversion
    wire [1:0] SP = {SP_gray[1], SP_gray[1] ^ SP_gray[0]};
    
    // Combinational flag assignments
    assign EMPTY = (SP_gray == 2'b00);
    assign FULL = (SP == 2'b11);

    // Memory write enable (clock gating)
    wire mem_write_en = EN && !RW && !FULL;
    wire mem_read_en = EN && RW && !EMPTY;

    // Stack pointer control logic
    always @(posedge Clk) begin
        if (Rst) begin
            SP_gray <= 2'b00;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push) - Gray code increment
                case (SP_gray)
                    2'b00: SP_gray <= 2'b01;
                    2'b01: SP_gray <= 2'b11;
                    2'b11: SP_gray <= 2'b10;
                    2'b10: SP_gray <= 2'b00; // Shouldn't happen (FULL)
                endcase
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop) - Gray code decrement
                case (SP_gray)
                    2'b00: SP_gray <= 2'b00; // Shouldn't happen (EMPTY)
                    2'b01: SP_gray <= 2'b00;
                    2'b11: SP_gray <= 2'b01;
                    2'b10: SP_gray <= 2'b11;
                endcase
            end
        end
    end

    // Memory and data output logic
    always @(posedge Clk) begin
        if (Rst) begin
            // Only clear first location (others will be cleared as needed)
            stack_mem[0] <= 4'b0;
            dataOut <= 4'b0;
        end
        else begin
            if (mem_write_en) begin
                stack_mem[SP] <= dataIn;
            end
            if (mem_read_en) begin
                dataOut <= stack_mem[SP-1];
            end
        end
    end

endmodule