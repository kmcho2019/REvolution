module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    reg [99:0] shifted_in;
    integer i;

    always @(*) begin
        // Circular shift for wrap-around handling
        shifted_in = {in[0], in[99:1]};

        // Process each bit position
        for (i = 0; i < 100; i = i + 1) begin
            // out_both calculation (current and left neighbor)
            if (i == 99) begin
                out_both[i] = 1'b0;  // Boundary condition
            end else begin
                out_both[i] = in[i] & in[i+1];
            end

            // out_any calculation (current and right neighbor)
            if (i == 0) begin
                out_any[i] = 1'b0;  // Boundary condition
            end else begin
                out_any[i] = in[i] | in[i-1];
            end

            // out_different calculation (current and left neighbor with wrap-around)
            out_different[i] = in[i] ^ shifted_in[i];
        end
    end

endmodule