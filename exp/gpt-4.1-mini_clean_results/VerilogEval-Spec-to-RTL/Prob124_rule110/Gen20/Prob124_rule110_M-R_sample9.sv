module Rule110Combinational (
    input  wire [511:0] current_state,
    output wire [511:0] next_state
);
    wire [513:0] ext_state = {1'b0, current_state, 1'b0};
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            wire left   = ext_state[i+2];
            wire center = ext_state[i+1];
            wire right  = ext_state[i];
            // next = (~left & center) | (center ^ right)
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate
endmodule

module Register512 (
    input  wire         clk,
    input  wire         load,
    input  wire         en,
    input  wire [511:0] d,
    output reg  [511:0] q
);
    always @(posedge clk) begin
        if (load)
            q <= d;
        else if (en)
            q <= d;
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    wire [511:0] next_state;

    // Instantiate the combinational next state generator
    Rule110Combinational next_logic (
        .current_state(q),
        .next_state(next_state)
    );

    // Instantiate the 512-bit register with load and enable
    // Enable updates next_state only when load is not active
    Register512 state_reg (
        .clk(clk),
        .load(load),
        .en(~load),
        .d(load ? data : next_state),
        .q(q)
    );

endmodule