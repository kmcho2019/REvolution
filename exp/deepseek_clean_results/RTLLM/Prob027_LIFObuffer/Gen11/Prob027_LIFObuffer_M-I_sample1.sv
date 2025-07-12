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
    
    // Stack pointer states (one-hot encoding for better synthesis)
    // 00001: empty (SP=4)
    // 00010: SP=3
    // 00100: SP=2
    // 01000: SP=1
    // 10000: full (SP=0)
    reg [4:0] SP_state;

    // Data change detection
    reg [3:0] prev_dataIn;
    wire data_changed = (prev_dataIn != dataIn);

    // Combinational flags
    assign EMPTY = (SP_state == 5'b00001);
    assign FULL = (SP_state == 5'b10000);

    always @(posedge Clk) begin
        if (Rst) begin
            // Parallel reset assignments
            SP_state <= 5'b00001;  // Empty state
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
            prev_dataIn <= 4'b0;
        end
        else if (EN) begin
            prev_dataIn <= dataIn;
            
            if (!RW && !FULL) begin
                // Write operation (push) - only if data changed
                if (data_changed) begin
                    case (SP_state)
                        5'b00001: stack_mem[3] <= dataIn;  // SP=4->3
                        5'b00010: stack_mem[2] <= dataIn;  // SP=3->2
                        5'b00100: stack_mem[1] <= dataIn;  // SP=2->1
                        5'b01000: stack_mem[0] <= dataIn;  // SP=1->0
                    endcase
                end
                
                // Update stack pointer state
                case (SP_state)
                    5'b00001: SP_state <= 5'b00010;  // SP=4->3
                    5'b00010: SP_state <= 5'b00100;  // SP=3->2
                    5'b00100: SP_state <= 5'b01000;  // SP=2->1
                    5'b01000: SP_state <= 5'b10000;  // SP=1->0
                endcase
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                case (SP_state)
                    5'b00010: dataOut <= stack_mem[3];  // SP=3
                    5'b00100: dataOut <= stack_mem[2];  // SP=2
                    5'b01000: dataOut <= stack_mem[1];  // SP=1
                    5'b10000: dataOut <= stack_mem[0];  // SP=0
                endcase
                
                // Update stack pointer state
                case (SP_state)
                    5'b00010: SP_state <= 5'b00001;  // SP=3->4
                    5'b00100: SP_state <= 5'b00010;  // SP=2->3
                    5'b01000: SP_state <= 5'b00100;  // SP=1->2
                    5'b10000: SP_state <= 5'b01000;  // SP=0->1
                endcase
            end
        end
    end

endmodule