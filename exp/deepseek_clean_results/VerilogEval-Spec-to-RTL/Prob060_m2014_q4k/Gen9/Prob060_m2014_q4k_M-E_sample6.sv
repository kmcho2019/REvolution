module TopModule (
    input clk,
    input resetn,
    input in,
    output reg out
);

    reg [3:0] shift_reg;
    reg [1:0] ptr;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            ptr <= 2'b0;
            out <= 1'b0;
        end
        else begin
            // Circular shift operation
            shift_reg <= {shift_reg[2:0], in};
            
            // Pointer increments every cycle (mod 4)
            ptr <= ptr + 1;
            
            // Output is always the oldest element (ptr position)
            out <= shift_reg[ptr];
        end
    end

endmodule