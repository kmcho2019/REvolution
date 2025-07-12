module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    reg [1:0] ptr;  // Pointer to oldest bit (output position)
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            ptr <= 2'b0;
        end
        else begin
            // Circular write - overwrite oldest position
            shift_reg[ptr] <= in;
            
            // Update pointer (circular increment)
            ptr <= ptr + 1;
        end
    end
    
    // Output is always the oldest bit (pointed to by ptr)
    assign out = shift_reg[ptr];

endmodule