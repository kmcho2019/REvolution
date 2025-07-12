module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    reg [99:0] next_q;

    // Generate next_q combinationally with conditional rotate and load
    // Use generate block to explicitly select per-bit next_q
    genvar i;
    wire [99:0] rotate_left, rotate_right;

    // Compute rotate-left and rotate-right only if enabled to avoid redundant logic
    // We'll compute rotate_left only if ena == 2'b10; else assign don't-care (optimized away)
    // Similarly for rotate_right (ena == 2'b01)
    // To express this cleanly, we first assign rotated versions and later mux select in generate

    // We can't conditionally assign wires inside generate, so assign always but rely on synthesis pruning
    assign rotate_left  = {q[98:0], q[99]};
    assign rotate_right = {q[0], q[99:1]};

    generate
        for (i=0; i<100; i=i+1) begin : gen_next_q
            always @* begin
                if (load) begin
                    next_q[i] = data[i];
                end else if (ena == 2'b10) begin
                    next_q[i] = rotate_left[i];
                end else if (ena == 2'b01) begin
                    next_q[i] = rotate_right[i];
                end else begin
                    next_q[i] = q[i];
                end
            end
        end
    endgenerate

    // Sequential update on clk
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule