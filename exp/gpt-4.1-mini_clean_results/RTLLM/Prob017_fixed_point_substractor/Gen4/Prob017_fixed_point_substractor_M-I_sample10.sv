module fixed_point_subtractor #(
    parameter integer N = 16, // Total bits (including sign)
    parameter integer Q = 8   // Fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal registers and wires
    reg [N-1:0] res;

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Function to compute absolute value (magnitude) of two's complement input
    function [N-1:0] abs_val;
        input [N-1:0] in;
        begin
            if(in[N-1] == 1'b1) // negative
                abs_val = (~in) + 1'b1;
            else
                abs_val = in;
        end
    endfunction

    // Compute magnitudes
    wire [N-1:0] mag_a = abs_val(a);
    wire [N-1:0] mag_b = abs_val(b);

    // Combinational logic for result
    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: subtraction of magnitudes
            // Result sign is sign_a
            if (mag_a >= mag_b) begin
                res = {sign_a, mag_a[N-2:0]} - {1'b0, mag_b[N-2:0]};
                res[N-1] = sign_a; // maintain sign
            end else begin
                res = {sign_a, mag_b[N-2:0]} - {1'b0, mag_a[N-2:0]};
                res[N-1] = sign_a;
            end
        end else begin
            // Different signs: add magnitudes
            // Result sign depends on which magnitude is greater
            if (mag_a >= mag_b) begin
                res = mag_a + mag_b;
                res[N-1] = sign_a; // sign of the bigger magnitude operand
            end else begin
                res = mag_a + mag_b;
                res[N-1] = sign_b;
            end
        end

        // If zero result (all bits except sign zero), sign forced to 0
        if ((res[N-2:0] == 0)) begin
            res[N-1] = 1'b0;
        end
    end

    assign c = res;

endmodule