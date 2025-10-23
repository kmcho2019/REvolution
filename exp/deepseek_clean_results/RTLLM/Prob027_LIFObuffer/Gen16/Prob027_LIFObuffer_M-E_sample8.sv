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

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Read and write pointers
    reg [1:0] w_ptr;  // Points to next write location
    reg [1:0] r_ptr;  // Points to last written location
    
    // Status flags
    reg empty, full;
    
    // Combinational outputs
    assign EMPTY = empty;
    assign FULL = full;
    assign dataOut = stack_mem[r_ptr];  // Always shows last written data
    
    // Pointer arithmetic
    wire [1:0] next_w_ptr = w_ptr + 1'b1;
    wire [1:0] prev_r_ptr = r_ptr - 1'b1;
    
    // Control logic
    always @(posedge Clk) begin
        if (Rst) begin
            w_ptr <= 0;
            r_ptr <= 0;
            empty <= 1'b1;
            full <= 1'b0;
        end
        else if (EN) begin
            case ({RW, full, empty})
                3'b000: begin  // Write when not full
                    stack_mem[w_ptr] <= dataIn;
                    w_ptr <= next_w_ptr;
                    r_ptr <= w_ptr;  // Update read pointer to new data
                    empty <= 1'b0;
                    full <= (next_w_ptr == r_ptr);
                end
                
                3'b100: begin  // Read when not empty
                    r_ptr <= prev_r_ptr;
                    w_ptr <= (w_ptr == 0) ? 2'd3 : w_ptr - 1'b1;
                    full <= 1'b0;
                    empty <= (prev_r_ptr == w_ptr);
                end
                
                default: ;  // No operation for invalid cases
            endcase
        end
    end
    
    // Initialize memory (optional)
    integer i;
    initial begin
        for (i = 0; i < 4; i = i + 1)
            stack_mem[i] = 4'b0;
    end

endmodule