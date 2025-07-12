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

    // Memory organized in two banks (even/odd)
    reg [3:0] mem_even [0:1];  // Bank 0 (even addresses)
    reg [3:0] mem_odd [0:1];   // Bank 1 (odd addresses)
    
    // Gray-coded pointers (3 bits: [2] = bank, [1:0] = position)
    reg [2:0] head_ptr;  // Write pointer
    reg [2:0] tail_ptr;  // Read pointer
    
    // Gray code increment function
    function [2:0] gray_inc;
        input [2:0] gray;
        reg [2:0] bin;
        begin
            bin = gray ^ (gray >> 1);  // Gray to binary
            bin = bin + 1;            // Increment
            gray_inc = bin ^ (bin >> 1); // Binary to Gray
        end
    endfunction

    // Status flags
    assign EMPTY = (head_ptr == tail_ptr);
    assign FULL = (gray_inc(head_ptr) == tail_ptr);

    // Memory write (push) operation
    always @(posedge Clk) begin
        if (Rst) begin
            head_ptr <= 3'b000;
            mem_even[0] <= 4'b0;
            mem_even[1] <= 4'b0;
            mem_odd[0] <= 4'b0;
            mem_odd[1] <= 4'b0;
        end
        else if (EN && !RW && !FULL) begin
            if (head_ptr[2]) begin  // Odd bank
                mem_odd[head_ptr[1:0]] <= dataIn;
            end
            else begin              // Even bank
                mem_even[head_ptr[1:0]] <= dataIn;
            end
            head_ptr <= gray_inc(head_ptr);
        end
    end

    // Memory read (pop) operation
    always @(posedge Clk) begin
        if (Rst) begin
            tail_ptr <= 3'b000;
            dataOut <= 4'b0;
        end
        else if (EN && RW && !EMPTY) begin
            if (tail_ptr[2]) begin  // Odd bank
                dataOut <= mem_odd[tail_ptr[1:0]];
            end
            else begin            // Even bank
                dataOut <= mem_even[tail_ptr[1:0]];
            end
            tail_ptr <= gray_inc(tail_ptr);
        end
    end

    // Power gating control (optional)
    // Would typically be implemented with clock gating cells in synthesis
    wire even_bank_active = (head_ptr[2] != tail_ptr[2]) || 
                          ((head_ptr[2] == 1'b0) && !EMPTY);
    wire odd_bank_active = (head_ptr[2] != tail_ptr[2]) ||
                         ((head_ptr[2] == 1'b1) && !EMPTY);

endmodule