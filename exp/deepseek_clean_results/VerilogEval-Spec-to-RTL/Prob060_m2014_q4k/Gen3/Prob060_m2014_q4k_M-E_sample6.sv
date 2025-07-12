module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] storage;
    reg [1:0] head_ptr;
    
    always @(posedge clk) begin
        if (!resetn) begin
            storage <= 4'b0;
            head_ptr <= 2'b0;
        end
        else begin
            // Update the current head position with new input
            storage[head_ptr] <= in;
            
            // Circular increment of head pointer
            head_ptr <= head_ptr + 1;
        end
    end
    
    // Output is always from position (head_ptr - 3) mod 4
    assign out = storage[(head_ptr - 2'd3) % 4];

endmodule