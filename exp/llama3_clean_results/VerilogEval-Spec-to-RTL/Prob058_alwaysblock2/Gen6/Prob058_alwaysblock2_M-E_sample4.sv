// Define a parameterizable module for the XOR gate
module xor_gate(
    input clk,
    input a,
    input b,
    input [1:0] mode, // 0: assign, 1: combinational always, 2: clocked always
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    reg [1:0] mode_reg;
    reg a_reg, b_reg;
    reg out_assign_reg, out_always_comb_reg, out_always_ff_reg;

    // Assign statement for out_assign
    assign out_assign = a ^ b;

    // Combinational always block for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Clocked always block for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

    // Pipelined implementation for out_always_ff
    reg [1:0] pipeline_stage;
    always_ff @(posedge clk) begin
        pipeline_stage[0] <= a;
        pipeline_stage[1] <= b;
        out_always_ff <= pipeline_stage[0] ^ pipeline_stage[1];
    end

    // Clock gating for out_always_ff
    reg clock_enable;
    always_ff @(posedge clk) begin
        if (clock_enable) begin
            out_always_ff <= a ^ b;
        end
    end

    // Select the appropriate implementation based on the mode parameter
    always_comb begin
        case (mode)
            2'b00: out_assign_reg = out_assign;
            2'b01: out_always_comb_reg = out_always_comb;
            2'b10: out_always_ff_reg = out_always_ff;
            default: out_assign_reg = 1'bx;
        endcase
    end

    // Assign the selected output to the output port
    assign out_assign = out_assign_reg;
    assign out_always_comb = out_always_comb_reg;
    assign out_always_ff = out_always_ff_reg;

endmodule