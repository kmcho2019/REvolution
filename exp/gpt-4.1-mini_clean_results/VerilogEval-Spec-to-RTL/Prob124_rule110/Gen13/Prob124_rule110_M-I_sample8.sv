module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Pipeline stage 0: registered version of q with zero-padding for boundaries
    reg [513:0] stage0_ext_q;

    // Pipeline stage 1: combinational next state from stage0_ext_q
    wire [511:0] next_q_stage1;

    // Rule 110 next state function: next = (~left & center) | (center ^ right)
    function automatic bit rule110_cell(input bit left, input bit center, input bit right);
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_next_state
            wire left   = stage0_ext_q[i+2];
            wire center = stage0_ext_q[i+1];
            wire right  = stage0_ext_q[i];
            assign next_q_stage1[i] = rule110_cell(left, center, right);
        end
    endgenerate

    // Stage 0 register update
    // Clock gate the stage0 pipeline update when load is high (loading input data)
    // to reduce switching (no evolution step when loading new data)
    always @(posedge clk) begin
        if (load) begin
            // Load stage0_ext_q with zero-padded input data
            stage0_ext_q <= {1'b0, data, 1'b0};
        end else begin
            // Update stage0_ext_q with zero-padded current q (evolving)
            stage0_ext_q <= {1'b0, q, 1'b0};
        end
    end

    // Final q register update on clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q_stage1;
        end
    end

endmodule