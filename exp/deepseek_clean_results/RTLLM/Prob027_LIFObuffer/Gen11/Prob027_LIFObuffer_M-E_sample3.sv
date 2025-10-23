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
    
    // Gray-coded pointers (2 bits each)
    reg [1:0] w_ptr, r_ptr;
    
    // Convert gray to binary for comparison
    wire [1:0] w_ptr_bin = {w_ptr[1], w_ptr[1] ^ w_ptr[0]};
    wire [1:0] r_ptr_bin = {r_ptr[1], r_ptr[1] ^ r_ptr[0]};
    
    // Pointer difference (for empty/full detection)
    wire [2:0] ptr_diff = {1'b0, w_ptr_bin} - {1'b0, r_ptr_bin};

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset only pointers (memory doesn't need clearing)
            w_ptr <= 2'b00;
            r_ptr <= 2'b00;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            // Update empty/full flags
            EMPTY <= (ptr_diff == 3'b000);
            FULL <= (ptr_diff == 3'b100);
            
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[w_ptr_bin] <= dataIn;
                // Gray code increment
                w_ptr <= w_ptr + 1;
                if (w_ptr == 2'b11) w_ptr <= 2'b00;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[r_ptr_bin];
                // Gray code increment
                r_ptr <= r_ptr + 1;
                if (r_ptr == 2'b11) r_ptr <= 2'b00;
            end
        end
    end

endmodule