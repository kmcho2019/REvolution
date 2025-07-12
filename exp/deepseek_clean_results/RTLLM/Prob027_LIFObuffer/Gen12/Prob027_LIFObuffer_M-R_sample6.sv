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
    
    // One-hot stack pointer (bit 4: empty, bit 0: full)
    reg [4:0] SP;

    // Combinational flag logic
    assign EMPTY = SP[4];
    assign FULL = SP[0];

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: clear stack and set SP to empty
            SP <= 5'b10000;
            dataOut <= 4'b0;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                case (SP)
                    5'b10000: begin // empty
                        stack_mem[3] <= dataIn;
                        SP <= 5'b01000;
                    end
                    5'b01000: begin // 1 entry
                        stack_mem[2] <= dataIn;
                        SP <= 5'b00100;
                    end
                    5'b00100: begin // 2 entries
                        stack_mem[1] <= dataIn;
                        SP <= 5'b00010;
                    end
                    5'b00010: begin // 3 entries
                        stack_mem[0] <= dataIn;
                        SP <= 5'b00001;
                    end
                endcase
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                case (SP)
                    5'b01000: begin // 1 entry
                        dataOut <= stack_mem[3];
                        SP <= 5'b10000;
                    end
                    5'b00100: begin // 2 entries
                        dataOut <= stack_mem[2];
                        SP <= 5'b01000;
                    end
                    5'b00010: begin // 3 entries
                        dataOut <= stack_mem[1];
                        SP <= 5'b00100;
                    end
                    5'b00001: begin // full
                        dataOut <= stack_mem[0];
                        SP <= 5'b00010;
                    end
                endcase
            end
        end
    end

endmodule