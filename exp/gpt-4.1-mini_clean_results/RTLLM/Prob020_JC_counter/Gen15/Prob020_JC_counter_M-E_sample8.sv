module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

    reg dir; // Direction bit: 1 means shifting in 1's, 0 means shifting in 0's

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q   <= 64'b0;
            dir <= 1'b1;
        end else begin
            // Update Q by shifting right and inserting dir bit
            Q <= {dir, Q[63:1]};
            // Toggle dir when Q is all zeros or all ones
            if ((Q == 64'b0) || (Q == ~64'b0))
                dir <= ~dir;
        end
    end

endmodule