module TopModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    logic [29:0] concatenated_vector;
    logic [31:0] appended_vector;
    logic [31:0] pipeline_stage1;
    logic [31:0] pipeline_stage2;

    // Concatenation stage
    assign concatenated_vector = {a, b, c, d, e, f};

    // Appending stage
    assign appended_vector = {concatenated_vector, 2'b11};

    // Pipeline stage 1
    always @(posedge clock) begin
        pipeline_stage1 <= appended_vector;
    end

    // Pipeline stage 2
    always @(posedge clock) begin
        pipeline_stage2 <= pipeline_stage1;
    end

    // Splitting stage
    assign w = pipeline_stage2[31:24];
    assign x = pipeline_stage2[23:16];
    assign y = pipeline_stage2[15:8];
    assign z = pipeline_stage2[7:0];

endmodule