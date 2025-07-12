// Parameterized module for AND and OR gates
module DynamicGates(
    input [2:0] p1a, p1b, p1c, p1d, p1e, p1f,
    input [1:0] p2a, p2b, p2c, p2d,
    output p1y,
    output p2y
);
    // Generate block for 3-input AND gates
    wire and1_out, and2_out;
    assign and1_out = p1a[0] & p1b[0] & p1c[0];
    assign and2_out = p1d[0] & p1e[0] & p1f[0];

    // Generate block for 2-input AND gates
    wire and3_out, and4_out;
    assign and3_out = p2a[0] & p2b[0];
    assign and4_out = p2c[0] & p2d[0];

    // Generate block for OR gates
    assign p1y = and1_out | and2_out;
    assign p2y = and3_out | and4_out;
endmodule

// TopModule with dynamic gates
module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);
    reg [2:0] p1a_reg, p1b_reg, p1c_reg, p1d_reg, p1e_reg, p1f_reg;
    reg [1:0] p2a_reg, p2b_reg, p2c_reg, p2d_reg;

    // Initialize registers with input values
    always @(p1a, p1b, p1c, p1d, p1e, p1f, p2a, p2b, p2c, p2d) begin
        p1a_reg = {2'b0, p1a};
        p1b_reg = {2'b0, p1b};
        p1c_reg = {2'b0, p1c};
        p1d_reg = {2'b0, p1d};
        p1e_reg = {2'b0, p1e};
        p1f_reg = {2'b0, p1f};
        p2a_reg = {1'b0, p2a};
        p2b_reg = {1'b0, p2b};
        p2c_reg = {1'b0, p2c};
        p2d_reg = {1'b0, p2d};
    end

    // Instantiate dynamic gates module
    DynamicGates dynamic_gates(
        .p1a(p1a_reg),
        .p1b(p1b_reg),
        .p1c(p1c_reg),
        .p1d(p1d_reg),
        .p1e(p1e_reg),
        .p1f(p1f_reg),
        .p2a(p2a_reg),
        .p2b(p2b_reg),
        .p2c(p2c_reg),
        .p2d(p2d_reg),
        .p1y(p1y),
        .p2y(p2y)
    );
endmodule