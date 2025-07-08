module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

// Parameters for pipeline stages and width per stage
localparam STAGES = 4;
localparam WIDTH  = 16;  // bits per stage

// Pipeline registers for partial sums and carries
reg [WIDTH-1:0] sum_stage [0:STAGES-1];
reg carry_stage [0:STAGES]; // carry_stage[0] is initial carry-in (0)

// Registers for input operands pipelined
reg [63:0] adda_pipe [0:STAGES-1];
reg [63:0] addb_pipe [0:STAGES-1];

// Pipeline register for i_en
reg i_en_pipe [0:STAGES];

// Intermediate carry wires for addition in each stage
wire [WIDTH-1:0] stage_add_a [0:STAGES-1];
wire [WIDTH-1:0] stage_add_b [0:STAGES-1];
wire carry_in [0:STAGES-1];
wire carry_out [0:STAGES-1];
wire [WIDTH-1:0] sum_wire [0:STAGES-1];

// Assign slices for each stage
genvar i;
generate
    for(i=0; i<STAGES; i=i+1) begin : assign_slices
        assign stage_add_a[i] = adda_pipe[i][WIDTH*i +: WIDTH];
        assign stage_add_b[i] = addb_pipe[i][WIDTH*i +: WIDTH];
    end
endgenerate

// Initial carry in is zero
assign carry_in[0] = carry_stage[0];
generate
    for(i=1; i<STAGES; i=i+1) begin : carry_connect
        assign carry_in[i] = carry_stage[i];
    end
endgenerate

// Combinational addition for each stage
generate
    for(i=0; i<STAGES; i=i+1) begin : comb_add
        assign {carry_out[i], sum_wire[i]} = stage_add_a[i] + stage_add_b[i] + carry_in[i];
    end
endgenerate

integer j;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers and control signals
        for (j=0; j<STAGES; j=j+1) begin
            adda_pipe[j] <= 64'b0;
            addb_pipe[j] <= 64'b0;
            sum_stage[j] <= {WIDTH{1'b0}};
            carry_stage[j] <= 1'b0;
            i_en_pipe[j] <= 1'b0;
        end
        carry_stage[STAGES] <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline input operands and enable
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        i_en_pipe[0] <= i_en;

        // Update pipeline registers for subsequent stages
        for (j=1; j<STAGES; j=j+1) begin
            adda_pipe[j] <= adda_pipe[j-1];
            addb_pipe[j] <= addb_pipe[j-1];
            i_en_pipe[j] <= i_en_pipe[j-1];
        end

        // Stage 0 sum and carry update
        sum_stage[0] <= sum_wire[0];
        carry_stage[1] <= carry_out[0];

        // Other stages sum and carry update
        for (j=1; j<STAGES; j=j+1) begin
            sum_stage[j] <= sum_wire[j];
            carry_stage[j+1] <= carry_out[j];
        end

        // Compose the final result after last stage
        // Concatenate sums from all stages and last carry out
        if (i_en_pipe[STAGES-1]) begin
            result <= {carry_out[STAGES-1],
                      sum_stage[STAGES-1],
                      sum_stage[STAGES-2],
                      sum_stage[STAGES-3],
                      sum_stage[STAGES-4]};
            o_en <= 1'b1;
        end else begin
            result <= result;
            o_en <= 1'b0;
        end
    end
end

// Initialize carry_stage[0] to zero at all times (fixed)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        carry_stage[0] <= 1'b0;
    end else begin
        carry_stage[0] <= 1'b0;
    end
end

endmodule