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

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // One-hot encoded stack pointer (5 states: 0-4)
    reg [4:0] SP;
    // Operation valid signals
    wire write_op = EN && !RW && !FULL;
    wire read_op = EN && RW && !EMPTY;
    
    // Next state flags
    reg next_empty, next_full;

    // Stack pointer update logic
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 5'b10000; // Empty state (SP=4)
        end
        else if (write_op) begin
            // Push operation
            case (SP)
                5'b10000: SP <= 5'b01000; // 4->3
                5'b01000: SP <= 5'b00100; // 3->2
                5'b00100: SP <= 5'b00010; // 2->1
                5'b00010: SP <= 5'b00001; // 1->0
                default: SP <= SP;
            endcase
        end
        else if (read_op) begin
            // Pop operation
            case (SP)
                5'b00001: SP <= 5'b00010; // 0->1
                5'b00010: SP <= 5'b00100; // 1->2
                5'b00100: SP <= 5'b01000; // 2->3
                5'b01000: SP <= 5'b10000; // 3->4
                default: SP <= SP;
            endcase
        end
    end

    // Memory write logic with gating
    always @(posedge Clk) begin
        if (write_op) begin
            case (SP)
                5'b10000: stack_mem[3] <= dataIn;
                5'b01000: stack_mem[2] <= dataIn;
                5'b00100: stack_mem[1] <= dataIn;
                5'b00010: stack_mem[0] <= dataIn;
                default: ; // No write when full
            endcase
        end
    end

    // Data output logic
    always @(posedge Clk) begin
        if (read_op) begin
            case (SP)
                5'b00001: dataOut <= stack_mem[0];
                5'b00010: dataOut <= stack_mem[1];
                5'b00100: dataOut <= stack_mem[2];
                5'b01000: dataOut <= stack_mem[3];
                default: dataOut <= 4'b0;
            endcase
        end
        else if (Rst) begin
            dataOut <= 4'b0;
        end
    end

    // Flag generation (pipelined)
    always @(posedge Clk) begin
        if (Rst) begin
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end
        else begin
            EMPTY <= (SP == 5'b10000);
            FULL <= (SP == 5'b00001);
        end
    end

endmodule