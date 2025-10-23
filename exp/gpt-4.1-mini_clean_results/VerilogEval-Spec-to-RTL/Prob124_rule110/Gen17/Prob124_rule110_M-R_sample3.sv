module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    // State register holding the current 512-cell configuration
    reg [511:0] q_reg;

    // Output is continuously driven by the state register
    assign q = q_reg;

    // Extended vector for boundary handling with zero-padding
    wire [513:0] ext_q = {1'b0, q_reg, 1'b0};

    // Combinational next state calculation
    wire [511:0] next_state;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            wire left   = ext_q[i + 2];
            wire center = ext_q[i + 1];
            wire right  = ext_q[i];
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Sequential update of the state register with synchronous load
    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_state;
    end

endmodule