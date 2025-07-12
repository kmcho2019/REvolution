module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        reg [7:0] temp_out;
        
        // Compute arithmetic result
        if (do_sub)
            temp_out = a - b;
        else
            temp_out = a + b;
        
        // Set outputs
        out = temp_out;
        result_is_zero = (temp_out == 8'b0);
    end

endmodule