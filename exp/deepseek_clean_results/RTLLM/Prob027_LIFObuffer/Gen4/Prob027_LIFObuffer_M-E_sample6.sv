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

    // Stack memory implemented as circular buffer
    reg [3:0] stack_mem [0:3];
    reg [1:0] head_ptr;  // Points to next empty location
    reg [1:0] tail_ptr;  // Points to oldest valid data
    
    // Status flags (combinational)
    wire empty_wire = (head_ptr == tail_ptr);
    wire full_wire = ((head_ptr + 1) == tail_ptr) || 
                    ((head_ptr == 2'd3) && (tail_ptr == 2'd0));
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all registers
            head_ptr <= 2'd0;
            tail_ptr <= 2'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            // Clear memory (optional)
            for (integer i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'b0;
        end
        else if (EN) begin
            case ({RW, full_wire, empty_wire})
                3'b0_0_x: begin  // Write when not full
                    stack_mem[head_ptr] <= dataIn;
                    head_ptr <= (head_ptr == 2'd3) ? 2'd0 : head_ptr + 1;
                end
                3'b1_x_0: begin  // Read when not empty
                    dataOut <= stack_mem[tail_ptr];
                    tail_ptr <= (tail_ptr == 2'd3) ? 2'd0 : tail_ptr + 1;
                end
                default: ;  // No operation
            endcase
            
            // Update status flags
            EMPTY <= empty_wire;
            FULL <= full_wire;
        end
    end
    
endmodule