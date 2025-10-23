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
    // Head pointer for writes, Tail pointer for reads
    reg [1:0] head_ptr, tail_ptr;
    // Counter for number of entries
    reg [2:0] count;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            head_ptr <= 2'd0;
            tail_ptr <= 2'd0;
            count <= 3'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b0_0_x: begin // Write operation (not full)
                    stack_mem[head_ptr] <= dataIn;
                    head_ptr <= head_ptr + 1;
                    count <= count + 1;
                    EMPTY <= 1'b0;
                    FULL <= (count == 3) ? 1'b1 : 1'b0;
                end
                3'b1_x_0: begin // Read operation (not empty)
                    dataOut <= stack_mem[tail_ptr];
                    tail_ptr <= tail_ptr + 1;
                    count <= count - 1;
                    FULL <= 1'b0;
                    EMPTY <= (count == 1) ? 1'b1 : 1'b0;
                end
                default: ; // No operation
            endcase
        end
    end

    // Combinational flag updates for better timing
    always @(*) begin
        EMPTY = (count == 0);
        FULL = (count == 4);
    end

endmodule