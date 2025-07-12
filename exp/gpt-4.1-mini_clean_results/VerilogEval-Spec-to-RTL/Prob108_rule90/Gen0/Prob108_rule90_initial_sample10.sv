module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;

    // Compute next state for each cell
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_next_state
            wire left  = (i == 0)   ? 1'b0 : q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule