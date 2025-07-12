module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Stage 1: Register the extended q vector (zero-padded)
    reg [513:0] q_stage1;

    // Next q computed combinationally from q_stage1
    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            // Neighborhood bits for cell i in q_stage1: left = q_stage1[i+2], center = q_stage1[i+1], right = q_stage1[i]
            wire left   = q_stage1[i + 2];
            wire center = q_stage1[i + 1];
            wire right  = q_stage1[i];
            // Rule 110 logic
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // Load q_stage1 with zero padding around data
            q_stage1 <= {1'b0, data, 1'b0};
        end else begin
            // Advance pipeline registers
            q_stage1 <= {1'b0, q, 1'b0};
            q <= next_q;
        end
    end

endmodule