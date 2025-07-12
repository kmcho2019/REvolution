module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline stages
    reg [511:0] current_state;
    reg [511:0] stage1_reg;
    reg [511:0] stage2_reg;
    reg [511:0] stage3_reg;
    wire [511:0] next_state;

    // Clock gating control
    wire update_en = load || (|current_state) || (|next_state);

    // Generate next state in 4 pipelined segments
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            // Left neighbor selection with boundary condition
            wire left = (i == 0) ? 1'b0 : current_state[i-1];
            // Right neighbor selection with boundary condition
            wire right = (i == 511) ? 1'b0 : current_state[i+1];
            
            // XOR computation with pipelining
            if (i < 128) begin
                assign next_state[i] = left ^ right;
            end else if (i < 256) begin
                assign next_state[i] = stage1_reg[i-128] ^ stage1_reg[i-127];
            end else if (i < 384) begin
                assign next_state[i] = stage2_reg[i-256] ^ stage2_reg[i-255];
            end else begin
                assign next_state[i] = stage3_reg[i-384] ^ stage3_reg[i-383];
            end
        end
    endgenerate

    // Pipelined update with clock gating
    always @(posedge clk) begin
        if (update_en) begin
            if (load) begin
                current_state <= data;
                q <= data;
            end else begin
                // Pipeline registers
                stage1_reg <= next_state[127:0];
                stage2_reg <= stage1_reg;
                stage3_reg <= stage2_reg;
                current_state <= {stage3_reg, next_state[511:384]};
                q <= {stage3_reg, next_state[511:384]};
            end
        end
    end

endmodule