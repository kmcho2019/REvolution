module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] state, next_state;

    integer i;
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // neighbors, zero at boundaries
            wire left = (i == 0) ? 1'b0 : state[i-1];
            wire right = (i == 511) ? 1'b0 : state[i+1];
            next_state[i] = left ^ right;
        end
    end

    always @(posedge clk) begin
        if (load)
            state <= data;
        else
            state <= next_state;
    end

    assign q = state;

endmodule