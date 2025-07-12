module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] accumulator_stage1;
reg [9:0] accumulator_stage2;
reg [3:0] state; // One-hot encoding: bit0=1st, bit1=2nd, bit2=3rd, bit3=4th
wire clk_gated;
wire [9:0] next_accum;

// Clock gating for power optimization
assign clk_gated = clk & (valid_in | (|state));

// Combinational next accumulator value
assign next_accum = (state[0]) ? data_in : 
                   (state[1]) ? accumulator_stage1 + data_in :
                   (state[2]) ? accumulator_stage2 + data_in :
                   accumulator_stage2 + data_in;

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        accumulator_stage1 <= 10'b0;
        accumulator_stage2 <= 10'b0;
        state <= 4'b0001;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        // Pipeline stage 1
        if (state[0] | state[1]) begin
            accumulator_stage1 <= next_accum;
        end

        // Pipeline stage 2
        if (state[1] | state[2]) begin
            accumulator_stage2 <= accumulator_stage1;
        end

        // State transition
        state <= {state[2:0], state[3]};

        // Output generation
        valid_out <= state[3];
        if (state[3]) begin
            data_out <= next_accum;
            accumulator_stage1 <= 10'b0;
            accumulator_stage2 <= 10'b0;
        end
    end
end

endmodule