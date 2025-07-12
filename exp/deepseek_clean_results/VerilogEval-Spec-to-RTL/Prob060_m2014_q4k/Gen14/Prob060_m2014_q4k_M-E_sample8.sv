module TopModule (
    input clk,
    input resetn,
    input in,
    output reg out
);

    reg [3:0] shift_reg;
    reg [1:0] write_ptr;
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            write_ptr <= 2'b0;
            out <= 1'b0;
        end
        else begin
            // Store input in current position
            shift_reg[write_ptr] <= in;
            
            // Update write pointer (circular)
            write_ptr <= write_ptr + 1;
            
            // Output is always the oldest bit (write_ptr+1 mod 4)
            case (write_ptr)
                2'b00: out <= shift_reg[1];
                2'b01: out <= shift_reg[2];
                2'b10: out <= shift_reg[3];
                2'b11: out <= shift_reg[0];
            endcase
        end
    end

endmodule