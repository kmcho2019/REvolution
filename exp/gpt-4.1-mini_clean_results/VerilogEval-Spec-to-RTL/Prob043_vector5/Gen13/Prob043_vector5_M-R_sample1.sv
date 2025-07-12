module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Pack inputs into vector with inputs[4]=a down to inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Function to compute the 25-bit comparison vector
    function [24:0] compute_eq_vector;
        input [4:0] vec;
        integer i, j;
        reg [24:0] temp_out;
        begin
            for (i = 0; i < 5; i = i + 1) begin
                for (j = 0; j < 5; j = j + 1) begin
                    int idx = 24 - (5 * i + j);
                    if (i <= j) begin
                        // Compute equality with XNOR for upper triangle and diagonal
                        temp_out[idx] = ~(vec[4 - i] ^ vec[4 - j]);
                    end else begin
                        // Reuse symmetric bit for lower triangle
                        int sym_idx = 24 - (5 * j + i);
                        temp_out[idx] = temp_out[sym_idx];
                    end
                end
            end
            compute_eq_vector = temp_out;
        end
    endfunction

    // Assign output using the function
    assign out = compute_eq_vector(inputs);

endmodule