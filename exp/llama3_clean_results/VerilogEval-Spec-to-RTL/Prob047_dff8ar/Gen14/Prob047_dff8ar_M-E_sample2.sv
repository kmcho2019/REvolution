// Generic D Flip-Flop module with active high asynchronous reset
module GenericDFF(
    input           clk,
    input           areset,
    input           d,
    output          q
);

    reg q_reg = 1'b0; // Initialize with reset value

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 1'b0; // Explicit reset handling
        end else begin
            q_reg <= d; // Simplified clock edge handling
        end
    end

    assign q = q_reg;

endmodule

// TopModule with 8 instances of GenericDFF
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            GenericDFF dff(
               .clk(clk),
               .areset(areset),
               .d(d[i]),
               .q(q[i])
            );
        end
    endgenerate

endmodule