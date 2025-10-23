module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    reg enable;

    // Generate XOR for each bit with boundary conditions
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            assign next_q[i] = left ^ right;
        end
    endgenerate

    // Enable logic - prevent unnecessary updates when not needed
    always @(posedge clk) begin
        enable <= ~load;  // Disable updates during load
    end

    // Sequential logic with enable
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (enable) begin
            q <= next_q;
        end
    end

endmodule