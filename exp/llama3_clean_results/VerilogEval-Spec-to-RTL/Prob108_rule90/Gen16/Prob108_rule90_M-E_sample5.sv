module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

// Parameters
parameter NUM_SEGMENTS = 16;
parameter SEGMENT_SIZE = 512 / NUM_SEGMENTS;

// Internal signals
reg [511:0] q_reg;
reg [511:0] next_state;
wire [511:0] pipeline_output;

// Pipeline stages
genvar i;
generate
    for (i = 0; i < NUM_SEGMENTS; i++) begin
        // Calculate the start and end indices of the current segment
        wire [31:0] start_idx = i * SEGMENT_SIZE;
        wire [31:0] end_idx = (i + 1) * SEGMENT_SIZE - 1;
        
        // Boundary conditions for the current segment
        wire left_bc = (i == 0)? 1'b0 : q_reg[start_idx - 1];
        wire right_bc = (i == NUM_SEGMENTS - 1)? 1'b0 : q_reg[end_idx + 1];
        
        // Pipeline stage for the current segment
        Rule90PipelineStage pipeline_stage(
           .clk(clk),
           .load(load),
           .data(q_reg[start_idx +: SEGMENT_SIZE]),
           .left_bc(left_bc),
           .right_bc(right_bc),
           .output(pipeline_output[start_idx +: SEGMENT_SIZE])
        );
    end
endgenerate

// Update q_reg with the output from the pipeline
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= pipeline_output;
    end
end

assign q = q_reg;

endmodule

// Rule 90 pipeline stage module
module Rule90PipelineStage (
    input clk,
    input load,
    input [31:0] data,
    input left_bc,
    input right_bc,
    output [31:0] output
);

reg [31:0] output_reg;

genvar i;
generate
    for (i = 0; i < 32; i++) begin
        wire left, center, right;
        assign left = (i == 0)? left_bc : data[i - 1];
        assign center = data[i];
        assign right = (i == 31)? right_bc : data[i + 1];
        
        assign output_reg[i] = left ^ right;
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        output_reg <= data;
    end else begin
        output_reg <= output_reg;
    end
end

assign output = output_reg;

endmodule