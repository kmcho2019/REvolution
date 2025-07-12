module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers to split next_state computation and update
    reg [511:0] next_state_stage;

    wire [511:0] next_state_comb;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule90_logic
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            assign next_state_comb[i] = left ^ right;
        end
    endgenerate

    // Clock gating enable: enable pipeline register update only when load is low
    wire enable_pipeline = ~load;

    // Stage 1: pipeline register captures combinational next_state
    always @(posedge clk) begin
        if (enable_pipeline)
            next_state_stage <= next_state_comb;
    end

    // Stage 2: q register updated from pipeline or loaded from data
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state_stage;
        end
    end

endmodule