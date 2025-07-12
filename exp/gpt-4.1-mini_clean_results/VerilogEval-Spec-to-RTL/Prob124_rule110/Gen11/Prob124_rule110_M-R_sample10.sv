module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    // Internal state register
    reg [511:0] q_reg;
    assign q = q_reg;

    // Extend q_reg with zero-padding for boundary handling
    wire [513:0] ext_q = {1'b0, q_reg, 1'b0};

    // Next state logic computed combinationally
    reg [511:0] next_q;

    // Rule 110 next state function
    function automatic bit rule110_cell(input bit left, input bit center, input bit right);
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    integer i;
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            next_q[i] = rule110_cell(ext_q[i+2], ext_q[i+1], ext_q[i]);
        end
    end

    // Sequential logic for q_reg update with load as synchronous reset/enable
    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_q;
    end

endmodule