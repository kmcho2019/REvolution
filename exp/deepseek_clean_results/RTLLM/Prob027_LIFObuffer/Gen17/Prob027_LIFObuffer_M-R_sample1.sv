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

    // Packed stack memory (4 entries x 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // One-hot stack pointer (3 bits: [2] is empty state)
    reg [2:0] SP; // 000=empty, 001=pos0, 010=pos1, 100=pos2

    // Combinational flag assignments
    assign EMPTY = (SP == 3'b000);
    assign FULL = (SP[1] & SP[0]); // SP == 3'b011 (pos3)

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'b000;  // Empty state
            dataOut <= 4'b0;
            stack_mem[0] <= 4'b0; // Only clear first location
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                case (SP)
                    3'b000: begin // Empty
                        stack_mem[0] <= dataIn;
                        SP <= 3'b001;
                    end
                    3'b001: begin // Pos0
                        stack_mem[1] <= dataIn;
                        SP <= 3'b010;
                    end
                    3'b010: begin // Pos1
                        stack_mem[2] <= dataIn;
                        SP <= 3'b100;
                    end
                    3'b100: begin // Pos2
                        stack_mem[3] <= dataIn;
                        SP <= 3'b011;
                    end
                endcase
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                case (SP)
                    3'b001: begin // Pos0
                        dataOut <= stack_mem[0];
                        SP <= 3'b000;
                    end
                    3'b010: begin // Pos1
                        dataOut <= stack_mem[1];
                        SP <= 3'b001;
                    end
                    3'b100: begin // Pos2
                        dataOut <= stack_mem[2];
                        SP <= 3'b010;
                    end
                    3'b011: begin // Pos3
                        dataOut <= stack_mem[3];
                        SP <= 3'b100;
                    end
                endcase
            end
        end
    end

endmodule