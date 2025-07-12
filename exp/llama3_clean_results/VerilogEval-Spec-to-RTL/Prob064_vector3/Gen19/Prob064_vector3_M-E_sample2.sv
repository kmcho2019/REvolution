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
    logic [7:0] w_reg;
    logic [7:0] x_reg;
    logic [7:0] y_reg;
    logic [7:0] z_reg;

    // Input Registration Stage
    logic [4:0] a_reg;
    logic [4:0] b_reg;
    logic [4:0] c_reg;
    logic [4:0] d_reg;
    logic [4:0] e_reg;
    logic [4:0] f_reg;

    always_ff @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        c_reg <= c;
        d_reg <= d;
        e_reg <= e;
        f_reg <= f;
    end

    // Concatenation Stage
    assign concatenated_vector = {a_reg, b_reg, c_reg, d_reg, e_reg, f_reg};

    // Appending Stage
    assign appended_vector = {concatenated_vector, 2'b11};

    // Splitting Stage
    assign w_reg = appended_vector[31:24];
    assign x_reg = appended_vector[23:16];
    assign y_reg = appended_vector[15:8];
    assign z_reg = appended_vector[7:0];

    // Output Registration Stage
    always_ff @(posedge clk) begin
        w <= w_reg;
        x <= x_reg;
        y <= y_reg;
        z <= z_reg;
    end

endmodule