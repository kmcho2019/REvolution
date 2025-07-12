module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] data_reg;
    reg [1:0] write_ptr;
    
    always @(posedge clk) begin
        if (!resetn) begin
            data_reg <= 4'b0;
            write_ptr <= 2'b0;
        end
        else begin
            data_reg[write_ptr] <= in;
            write_ptr <= write_ptr + 1;
        end
    end
    
    // Output is from the previous position (circular)
    assign out = data_reg[(write_ptr - 1)];

endmodule