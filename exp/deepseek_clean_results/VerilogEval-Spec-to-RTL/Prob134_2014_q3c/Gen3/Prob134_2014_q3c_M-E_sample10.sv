module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // State definitions
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // Next state computation (parallel for all states)
    wire [2:0] next_S0 = x ? S1 : S0;
    wire [2:0] next_S1 = x ? S4 : S1;
    wire [2:0] next_S2 = x ? S1 : S2;
    wire [2:0] next_S3 = x ? S2 : S1;
    wire [2:0] next_S4 = x ? S4 : S3;

    // State selection mux
    wire [2:0] Y = 
        (y == S0) ? next_S0 :
        (y == S1) ? next_S1 :
        (y == S2) ? next_S2 :
        (y == S3) ? next_S3 :
        (y == S4) ? next_S4 :
        3'b000; // default case

    // Output logic
    assign z = (y == S3) || (y == S4);
    assign Y0 = Y[0];

endmodule