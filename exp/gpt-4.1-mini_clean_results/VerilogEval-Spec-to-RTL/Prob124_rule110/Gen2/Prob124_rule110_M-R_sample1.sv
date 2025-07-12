module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Function to compute Rule 110 next state of one cell
    // Inputs are left, center, right bits
    function automatic bit rule110_cell(
        input bit left,
        input bit center,
        input bit right
    );
        // next_state = (~left & center) | (center ^ right)
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            assign next_q[i] = rule110_cell(left, center, right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;       // Load input data immediately
        end else begin
            q <= next_q;     // Update all cells simultaneously
        end
    end

endmodule