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
    assign FULL = (SP_gray == 2'b11);

    // Memory write enable
    wire mem_write = EN && !RW && !FULL;
    wire mem_read = EN && RW && !EMPTY;

    // Stack pointer control and memory logic
    always @(posedge Clk) begin
        if (Rst) begin
            SP_gray <= 2'b00;
            stack_mem[0] <= 4'b0;
            dataOut <= 4'b0;
        end
        else begin
            if (mem_write) begin
                // Write operation (push)
                case (SP_gray)
                    2'b00: begin
                        stack_mem[0] <= dataIn;
                        SP_gray <= 2'b01;
                    end
                    2'b01: begin
                        stack_mem[1] <= dataIn;
                        SP_gray <= 2'b11;
                    end
                    2'b11: begin
                        stack_mem[2] <= dataIn;
                        SP_gray <= 2'b10;
                    end
                    2'b10: begin
                        stack_mem[3] <= dataIn;
                        SP_gray <= 2'b00; // Should never reach here (FULL)
                    end
                endcase
            end
            else if (mem_read) begin
                // Read operation (pop)
                case (SP_gray)
                    2'b01: begin
                        dataOut <= stack_mem[0];
                        SP_gray <= 2'b00;
                    end
                    2'b11: begin
                        dataOut <= stack_mem[1];
                        SP_gray <= 2'b01;
                    end
                    2'b10: begin
                        dataOut <= stack_mem[2];
                        SP_gray <= 2'b11;
                    end
                    2'b00: begin
                        // Should never reach here (EMPTY)
                        SP_gray <= 2'b00;
                    end
                endcase
            end
        end
    end

endmodule