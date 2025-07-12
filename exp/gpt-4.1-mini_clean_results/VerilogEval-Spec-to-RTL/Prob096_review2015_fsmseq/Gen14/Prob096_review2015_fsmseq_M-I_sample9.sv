module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding (binary)
    // 0: no match
    // 1: matched '1'
    // 2: matched "11"
    // 3: matched "110"
    // 4: matched "1101" (final sticky)
    reg [2:0] state, next_state;

    // Clock gating enable signal registered to avoid glitches on gated clock
    reg clk_en;

    // Next state function for clarity and potential better synthesis optimization
    function [2:0] f_next_state;
        input [2:0] st;
        input       d;
        begin
            case (st)
                3'd0: f_next_state = d ? 3'd1 : 3'd0;
                3'd1: f_next_state = d ? 3'd2 : 3'd0;
                3'd2: f_next_state = d ? 3'd2 : 3'd3;
                3'd3: f_next_state = d ? 3'd4 : 3'd0;
                3'd4: f_next_state = 3'd4;
                default: f_next_state = 3'd0;
            endcase
        end
    endfunction

    // Register clk_en to enable clock gating, asserted until detection or reset
    always @(posedge clk) begin
        if (reset)
            clk_en <= 1'b1; // enable clock when resetting
        else if (state == 3'd4)
            clk_en <= 1'b0; // disable clock updates after detection
        else
            clk_en <= clk_en; // hold value
    end

    // Generate gated clock (simple AND gate; in real designs, use clock gating cells)
    wire gated_clk = clk & clk_en;

    // State register with synchronous reset, triggered on gated clock to reduce toggling
    always @(posedge gated_clk) begin
        if (reset)
            state <= 3'd0;
        else
            state <= f_next_state(state, data);
    end

    // Output: high once the sequence is found, sticky until reset
    assign start_shifting = (state == 3'd4);

endmodule