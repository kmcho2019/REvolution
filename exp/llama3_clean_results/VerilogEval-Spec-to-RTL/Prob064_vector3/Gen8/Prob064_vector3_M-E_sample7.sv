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

    // InputVectorRegister module
    logic [4:0] registered_a;
    logic [4:0] registered_b;
    logic [4:0] registered_c;
    logic [4:0] registered_d;
    logic [4:0] registered_e;
    logic [4:0] registered_f;

    always_ff @(posedge clk) begin
        registered_a <= a;
        registered_b <= b;
        registered_c <= c;
        registered_d <= d;
        registered_e <= e;
        registered_f <= f;
    end

    // ConcatenationModule
    logic [29:0] concatenated_vector;
    assign concatenated_vector = {registered_a, registered_b, registered_c, registered_d, registered_e, registered_f};

    // Append two '1' bits to the concatenated vector
    logic [31:0] appended_vector;
    assign appended_vector = {concatenated_vector, 2'b11};

    // OutputVectorSegmenter module
    logic [7:0] segmented_w;
    logic [7:0] segmented_x;
    logic [7:0] segmented_y;
    logic [7:0] segmented_z;

    always_ff @(posedge clk) begin
        segmented_w <= appended_vector[31:24];
        segmented_x <= appended_vector[23:16];
        segmented_y <= appended_vector[15:8];
        segmented_z <= appended_vector[7:0];
    end

    // Assign segmented vectors to output
    assign w = segmented_w;
    assign x = segmented_x;
    assign y = segmented_y;
    assign z = segmented_z;

endmodule