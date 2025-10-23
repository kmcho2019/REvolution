module TopModule (
    input clk,
    input in,
    output reg out
);

    // Function to compute XOR of two inputs
    function automatic xor2;
        input a, b;
        begin
            xor2 = a ^ b;
        end
    endfunction

    always @(posedge clk) begin
        out <= xor2(in, out);
    end

endmodule