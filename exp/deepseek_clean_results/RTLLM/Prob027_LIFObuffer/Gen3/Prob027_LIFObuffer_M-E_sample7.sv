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

    parameter DEPTH = 4;
    localparam PTR_WIDTH = $clog2(DEPTH+1);
    
    // Gray-coded pointers
    reg [PTR_WIDTH-1:0] head_ptr, tail_ptr;
    reg [PTR_WIDTH-1:0] head_ptr_gray, tail_ptr_gray;
    
    // Memory array
    reg [3:0] buffer_mem [0:DEPTH-1];
    
    // Flags
    assign EMPTY = (head_ptr == tail_ptr);
    assign FULL = ((head_ptr + 1) % (DEPTH+1)) == tail_ptr;
    
    // Output pipeline register
    reg [3:0] next_dataOut;
    
    // Pointer conversion to gray code
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction
    
    always @(posedge Clk) begin
        if (Rst) begin
            head_ptr <= 0;
            tail_ptr <= 0;
            head_ptr_gray <= 0;
            tail_ptr_gray <= 0;
            dataOut <= 0;
        end else if (EN) begin
            // Update pointers
            if (!RW && !FULL) begin  // Write operation
                buffer_mem[head_ptr[PTR_WIDTH-2:0]] <= dataIn;
                head_ptr <= (head_ptr + 1) % (DEPTH+1);
            end
            else if (RW && !EMPTY) begin  // Read operation
                next_dataOut <= buffer_mem[tail_ptr[PTR_WIDTH-2:0]];
                tail_ptr <= (tail_ptr + 1) % (DEPTH+1);
            end
            
            // Update gray-coded pointers
            head_ptr_gray <= bin2gray(head_ptr);
            tail_ptr_gray <= bin2gray(tail_ptr);
            
            // Pipeline output data
            dataOut <= next_dataOut;
        end
    end

endmodule