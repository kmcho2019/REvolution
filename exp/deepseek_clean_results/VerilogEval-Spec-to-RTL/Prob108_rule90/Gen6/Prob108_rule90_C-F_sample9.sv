module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] q_reg;
    wire [511:0] next_state;

    // Shared boundary signals
    wire left_boundary = 1'b0;
    wire right_boundary = 1'b0;

    // Combinational logic for Rule 90 with pipelining
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            // Neighbor selection with shared boundaries
            wire left = (i == 0) ? left_boundary : q_reg[i-1];
            wire right = (i == 511) ? right_boundary : q_reg[i+1];
            
            // Conditional evaluation to reduce power
            assign next_state[i] = (left || right) ? (left ^ right) : 1'b0;
        end
    endgenerate

    // Two-stage pipeline
    always @(posedge clk) begin
        // Stage 1: Register current state
        if (load) begin
            q_reg <= data;
            q <= data;
        end else begin
            q_reg <= q;
            
            // Stage 2: Update to next state
            q <= next_state;
        end
    end

endmodule