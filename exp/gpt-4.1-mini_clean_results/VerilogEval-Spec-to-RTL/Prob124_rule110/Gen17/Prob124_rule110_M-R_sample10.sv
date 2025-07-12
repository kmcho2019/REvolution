module StateRegister512 (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] d,
    input  wire [511:0] next_state,
    output reg  [511:0] q
);
    always @(posedge clk) begin
        if (load)
            q <= d;
        else
            q <= next_state;
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Internal state wire from state register
    wire [511:0] state_q;

    // Zero-pad the state for boundary conditions (left and right neighbors zero)
    wire [513:0] ext_state_q = {1'b0, state_q, 1'b0};

    // Function to compute next cell state per Rule 110
    function automatic logic cell_next_state(
        input logic left,
        input logic center,
        input logic right
    );
        begin
            // According to Rule 110:
            // next = (~left & center) | (center ^ right)
            cell_next_state = (~left & center) | (center ^ right);
        end
    endfunction

    // Generate the next state combinationally
    wire [511:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            assign next_q[i] = cell_next_state(
                ext_state_q[i+2],    // left neighbor
                ext_state_q[i+1],    // center
                ext_state_q[i]       // right neighbor
            );
        end
    endgenerate

    // Instantiate the state register module
    StateRegister512 state_reg_inst (
        .clk(clk),
        .load(load),
        .d(data),
        .next_state(next_q),
        .q(state_q)
    );

    assign q = state_q;

endmodule