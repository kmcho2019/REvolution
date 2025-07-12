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

    // Memory array (4 entries of 4 bits each)
    reg [3:0] buffer_mem [0:3];
    
    // Gray-coded pointers (2 bits each)
    reg [1:0] head_ptr, tail_ptr;
    wire [1:0] head_ptr_gray, tail_ptr_gray;
    
    // Binary pointers for calculations
    reg [1:0] head_ptr_bin, tail_ptr_bin;
    
    // Direction flag (0 = push mode, 1 = pop mode)
    reg direction;
    
    // Operation signals
    wire operation_valid = EN && ((!RW && !FULL) || (RW && !EMPTY));
    wire is_push = operation_valid && !RW;
    wire is_pop = operation_valid && RW;
    
    // Gray code converters
    assign head_ptr_gray = head_ptr_bin ^ (head_ptr_bin >> 1);
    assign tail_ptr_gray = tail_ptr_bin ^ (tail_ptr_bin >> 1);
    
    // Status flags (combinational)
    assign EMPTY = (head_ptr_gray == tail_ptr_gray) && !direction;
    assign FULL = (head_ptr_gray == tail_ptr_gray) && direction;
    
    // Pointer update logic
    always @(*) begin
        if (Rst) begin
            head_ptr_bin = 2'b00;
            tail_ptr_bin = 2'b00;
        end
        else if (is_push) begin
            head_ptr_bin = head_ptr + 1;
            tail_ptr_bin = tail_ptr;
        end
        else if (is_pop) begin
            head_ptr_bin = head_ptr - 1;
            tail_ptr_bin = tail_ptr;
        end
        else begin
            head_ptr_bin = head_ptr;
            tail_ptr_bin = tail_ptr;
        end
    end
    
    // Main sequential logic
    always @(posedge Clk) begin
        if (Rst) begin
            head_ptr <= 2'b00;
            tail_ptr <= 2'b00;
            direction <= 0;
            dataOut <= 4'b0;
        end
        else if (operation_valid) begin
            if (is_push) begin
                // Push operation
                buffer_mem[head_ptr] <= dataIn;
                head_ptr <= head_ptr_gray;
                
                // Set direction when buffer becomes non-empty
                if (EMPTY) direction <= 1;
                
                // Set FULL flag if we're about to wrap around
                if (head_ptr_bin == tail_ptr_bin - 1) direction <= 0;
            end
            else if (is_pop) begin
                // Pop operation
                dataOut <= buffer_mem[head_ptr];
                head_ptr <= head_ptr_gray;
                
                // Set direction when buffer becomes empty
                if (head_ptr_bin == tail_ptr_bin) direction <= 0;
            end
        end
    end

endmodule