module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output reg [64:0] result,
    output reg      o_en
);

// Parameters to define pipeline stages
// Let's divide 64 bits into 8 stages of 8 bits each
localparam STAGES = 8;
localparam WIDTH  = 8; // bits per stage

// Registers to hold operands segments
reg [WIDTH-1:0] adda_reg [0:STAGES-1];
reg [WIDTH-1:0] addb_reg [0:STAGES-1];

// Registers for sum segments and carry signals between stages
reg [WIDTH-1:0] sum_reg [0:STAGES-1];
reg carry_reg [0:STAGES];

// Pipeline enable registers to track valid data through stages
reg en_reg [0:STAGES];

// Intermediate carry wire for combinational addition at each stage
wire [WIDTH:0] adder_out [0:STAGES-1];

// Stage 0 input registers
reg [63:0] adda_in_reg;
reg [63:0] addb_in_reg;
reg        i_en_reg;

// Split input operands into segments and register them at stage 0
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_in_reg <= 64'b0;
        addb_in_reg <= 64'b0;
        i_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            adda_in_reg <= adda;
            addb_in_reg <= addb;
            i_en_reg <= 1'b1;
        end else begin
            i_en_reg <= 1'b0;
        end
    end
end

// Split the registered inputs into 8-bit chunks for stage 0
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < STAGES; i = i + 1) begin
            adda_reg[i] <= {WIDTH{1'b0}};
            addb_reg[i] <= {WIDTH{1'b0}};
        end
    end else if (i_en_reg) begin
        for (i = 0; i < STAGES; i = i + 1) begin
            adda_reg[i] <= adda_in_reg[i*WIDTH +: WIDTH];
            addb_reg[i] <= addb_in_reg[i*WIDTH +: WIDTH];
        end
    end
end

// The first carry-in is zero
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        carry_reg[0] <= 1'b0;
    end else if (i_en_reg) begin
        carry_reg[0] <= 1'b0;
    end
end

// Generate combinational adder outputs for each stage
genvar gi;
generate
    for (gi = 0; gi < STAGES; gi = gi + 1) begin : adder_stage_comb
        assign adder_out[gi] = adda_reg[gi] + addb_reg[gi] + carry_reg[gi];
    end
endgenerate

// Pipeline registers for sums and carry propagation through stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < STAGES; i = i + 1) begin
            sum_reg[i] <= {WIDTH{1'b0}};
            carry_reg[i+1] <= 1'b0;
            en_reg[i] <= 1'b0;
        end
        o_en <= 1'b0;
        result <= {(65){1'b0}};
    end else begin
        // Stage 0 registers sums and carry-outs and propagate enable
        sum_reg[0] <= adder_out[0][WIDTH-1:0];
        carry_reg[1] <= adder_out[0][WIDTH];
        en_reg[0] <= i_en_reg;

        // From stage 1 to stage 7 propagate sums and carries
        for (i = 1; i < STAGES; i = i + 1) begin
            sum_reg[i] <= adder_out[i][WIDTH-1:0];
            carry_reg[i+1] <= adder_out[i][WIDTH];
            en_reg[i] <= en_reg[i-1];
        end

        // When the last stage is done, output the final result and enable
        o_en <= en_reg[STAGES-1];
        if (en_reg[STAGES-1]) begin
            // Assemble the final 65-bit result: all 8-bit sums + final carry out
            result <= {
                carry_reg[STAGES],
                sum_reg[STAGES-1],
                sum_reg[STAGES-2],
                sum_reg[STAGES-3],
                sum_reg[STAGES-4],
                sum_reg[STAGES-5],
                sum_reg[STAGES-6],
                sum_reg[STAGES-7],
                sum_reg[0]
            };
        end else begin
            result <= {(65){1'b0}};
        end
    end
end

endmodule