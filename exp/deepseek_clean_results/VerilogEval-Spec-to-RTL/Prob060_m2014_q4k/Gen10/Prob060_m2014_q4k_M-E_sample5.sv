module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    reg [1:0] write_ptr;
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            write_ptr <= 2'b0;
        end
        else begin
            shift_reg[write_ptr] <= in;
            write_ptr <= write_ptr + 1;
        end
    end
    
    // Output is always the oldest element (write_ptr-1)
    assign out = shift_reg[(write_ptr - 1)];
    
endmodule