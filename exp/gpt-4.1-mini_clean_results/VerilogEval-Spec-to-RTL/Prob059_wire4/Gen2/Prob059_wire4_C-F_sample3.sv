module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Internal combinational signals
    wire w_int, x_int, y_int, z_int;

    // Combinational logic in always_comb for explicitness
    always @* begin
        // Assign internal signals
        w_int = a;
        x_int = b;
        y_int = b;
        z_int = c;
    end

    // Continuous assignments from internal signals to outputs
    assign w = w_int;
    assign x = x_int;
    assign y = y_int;
    assign z = z_int;

endmodule