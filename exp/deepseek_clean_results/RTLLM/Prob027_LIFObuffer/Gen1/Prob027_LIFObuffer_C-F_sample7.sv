module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Stack pointer (0=full, 4=empty)
    reg [2:0] SP;
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset initialization
            SP <= 3'd4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            // Clear stack memory
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b0_0_x: begin // Write operation (push) when not full
                    stack_mem[SP-1] <= dataIn;
                    SP <= SP - 1;
                    EMPTY <= 1'b0;
                    FULL <= (SP == 3'd1);
                end
                3'b1_x_0: begin // Read operation (pop) when not empty
                    dataOut <= stack_mem[SP];
                    SP <= SP + 1;
                    FULL <= 1'b0;
                    EMPTY <= (SP == 3'd3);
                end
                default: ; // No operation
            endcase
        end
    end
    
    // Continuous assignments for flags (alternative approach)
    // assign EMPTY = (SP == 3'd4);
    // assign FULL = (SP == 3'd0);
    
endmodule