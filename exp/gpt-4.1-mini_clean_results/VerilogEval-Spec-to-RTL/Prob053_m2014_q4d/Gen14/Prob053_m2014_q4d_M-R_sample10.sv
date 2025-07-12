module TopModule (
    input clk,
    input in,
    output reg out
);

    // Function to compute XOR of two inputs
    function xor_func;
        input a, b;
        begin
            xor_func = a ^ b;
        end
    endfunction

    always @(posedge clk) begin
        out <= xor_func(in, out);
    end

endmodule