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

    // One-hot encoded stack pointer (4 positions + empty state)
    reg [4:0] SP; // bit0:empty, bit1:pos0, bit2:pos1, bit3:pos2, bit4:pos3
    reg [3:0] stack_mem [0:3];
    reg [3:0] out_reg;

    // Combinational outputs
    assign EMPTY = SP[0];
    assign FULL = SP[4];
    assign dataOut = out_reg;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 5'b00001; // Empty state
            out_reg <= 4'b0;
        end
        else if (EN) begin
            // Write operation (push)
            if (!RW && !FULL) begin
                case (SP)
                    5'b00001: begin // Empty
                        stack_mem[0] <= dataIn;
                        SP <= 5'b00010;
                    end
                    5'b00010: begin // Pos0
                        stack_mem[1] <= dataIn;
                        SP <= 5'b00100;
                    end
                    5'b00100: begin // Pos1
                        stack_mem[2] <= dataIn;
                        SP <= 5'b01000;
                    end
                    5'b01000: begin // Pos2
                        stack_mem[3] <= dataIn;
                        SP <= 5'b10000;
                    end
                endcase
            end
            // Read operation (pop)
            else if (RW && !EMPTY) begin
                case (SP)
                    5'b00010: begin // Pos0
                        out_reg <= stack_mem[0];
                        SP <= 5'b00001;
                    end
                    5'b00100: begin // Pos1
                        out_reg <= stack_mem[1];
                        SP <= 5'b00010;
                    end
                    5'b01000: begin // Pos2
                        out_reg <= stack_mem[2];
                        SP <= 5'b00100;
                    end
                    5'b10000: begin // Pos3
                        out_reg <= stack_mem[3];
                        SP <= 5'b01000;
                    end
                endcase
            end
        end
    end

endmodule