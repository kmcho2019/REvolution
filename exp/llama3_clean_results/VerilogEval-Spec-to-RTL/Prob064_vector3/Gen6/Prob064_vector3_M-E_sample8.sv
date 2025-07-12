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
    output logic [7:0] z,
    input  logic clk,
    input  logic rst_n
);

    logic [29:0] registered_inputs;
    logic [31:0] concatenated_vector;
    logic [31:0] output_vector;

    // Input Registration
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            registered_inputs <= 30'd0;
        end else begin
            registered_inputs <= {a, b, c, d, e, f};
        end
    end

    // Concatenation and Appending
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            concatenated_vector <= 32'd0;
        end else begin
            concatenated_vector <= {registered_inputs, 2'b11};
        end
    end

    // Output Splitting
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            output_vector <= 32'd0;
        end else begin
            output_vector <= concatenated_vector;
        end
    end

    assign w = output_vector[31:24];
    assign x = output_vector[23:16];
    assign y = output_vector[15:8];
    assign z = output_vector[7:0];

endmodule