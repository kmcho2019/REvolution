module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] temp_res; // Temporary result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same signs
        temp_res = a + b;
    end else begin // Different signs
        if (a >= b) begin
            temp_res = a - b;
        end else begin
            temp_res = b - a;
        end
    end

    // Handle overflow and underflow
    if (temp_res >= (1 << N) - 1) begin
        c = (1 << N) - 1;
    end else if (temp_res < 0) begin
        c = 0;
    end else begin
        c = temp_res;
    end
end

endmodule