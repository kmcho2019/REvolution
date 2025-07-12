module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_logic
            wire left_bit  = (i == 0)   ? 1'b0 : q[i-1];
            wire right_bit = (i == 511) ? 1'b0 : q[i+1];
            assign next_state[i] = left_bit ^ right_bit;
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule