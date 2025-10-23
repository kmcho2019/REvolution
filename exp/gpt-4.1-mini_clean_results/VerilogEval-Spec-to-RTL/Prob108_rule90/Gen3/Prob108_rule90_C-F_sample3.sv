module TopModule (
    input          clk,
    input          load,
    input  [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_reg;
    wire [511:0] next_state;

    // Local copy to reduce fanout on q_reg in next_state computation
    wire [511:0] curr_state = q_reg;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule90_cell
            wire left  = (i == 0)    ? 1'b0 : curr_state[i-1];
            wire right = (i == 511)  ? 1'b0 : curr_state[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_state;
    end

    // Output driven from registered state
    always @(posedge clk) begin
        q <= q_reg;
    end

endmodule