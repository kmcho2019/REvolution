module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state_reg;
    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule90_logic
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            next_state_reg <= 512'b0;  // clear pipeline stage on load to avoid glitches
        end else begin
            next_state_reg <= next_state;
            q <= next_state_reg;
        end
    end

endmodule