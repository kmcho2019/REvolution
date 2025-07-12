module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding using localparams for better readability
    localparam STATE_000 = 3'b000,
               STATE_001 = 3'b001,
               STATE_010 = 3'b010,
               STATE_011 = 3'b011,
               STATE_100 = 3'b100;

    reg [2:0] state, next_state;
    wire z_wire;

    // Next state combinational logic using assign
    assign next_state = (state == STATE_000) ? (x ? STATE_001 : STATE_000) :
                        (state == STATE_001) ? (x ? STATE_100 : STATE_001) :
                        (state == STATE_010) ? (x ? STATE_001 : STATE_010) :
                        (state == STATE_011) ? (x ? STATE_010 : STATE_001) :
                        (state == STATE_100) ? (x ? STATE_100 : STATE_011) :
                        STATE_000; // default fallback

    // Output combinational logic using assign
    assign z_wire = (state == STATE_011) || (state == STATE_100);

    // Synchronous state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= STATE_000;
        else
            state <= next_state;
    end

    // Connect output
    assign z = z_wire;

endmodule