module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    reg [9:0] shift_reg;
    integer i;

    // Function to create unary pattern: number of ones equal to data, rest zeros
    function [9:0] bin_to_unary;
        input [9:0] val;
        integer j;
        begin
            bin_to_unary = 10'b0;
            for (j = 0; j < 10; j = j +1) begin
                if (j < val)
                    bin_to_unary[9-j] = 1'b1; // MSB corresponds to bit 9
                else
                    bin_to_unary[9-j] = 1'b0;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            // Load unary pattern representing 'data' ones at MSBs
            shift_reg <= bin_to_unary(data);
        end else begin
            if (|shift_reg)
                shift_reg <= {1'b0, shift_reg[9:1]}; // Shift right by 1 bit
            else
                shift_reg <= shift_reg; // Stay zero
        end
    end

    assign tc = ~|shift_reg; // Terminal count when all bits zero

endmodule