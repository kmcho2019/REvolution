module TopModule #(
    parameter INPUT_A_CONNECTION = 1, // Connection for input a (1: w, 2: x, 3: y, 4: z)
    parameter INPUT_B_CONNECTION = 2, // Connection for input b (1: w, 2: x, 3: y, 4: z)
    parameter INPUT_C_CONNECTION = 4  // Connection for input c (1: w, 2: x, 3: y, 4: z)
) (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

// Use generate statements to create connections based on configuration parameters
generate
    if (INPUT_A_CONNECTION == 1) begin
        assign w = a;
    end else if (INPUT_A_CONNECTION == 2) begin
        assign x = a;
    end else if (INPUT_A_CONNECTION == 3) begin
        assign y = a;
    end else if (INPUT_A_CONNECTION == 4) begin
        assign z = a;
    end

    if (INPUT_B_CONNECTION == 1) begin
        assign w = b;
    end else if (INPUT_B_CONNECTION == 2) begin
        assign x = b;
    end else if (INPUT_B_CONNECTION == 3) begin
        assign y = b;
    end else if (INPUT_B_CONNECTION == 4) begin
        assign z = b;
    end

    if (INPUT_C_CONNECTION == 1) begin
        assign w = c;
    end else if (INPUT_C_CONNECTION == 2) begin
        assign x = c;
    end else if (INPUT_C_CONNECTION == 3) begin
        assign y = c;
    end else if (INPUT_C_CONNECTION == 4) begin
        assign z = c;
    end
endgenerate

endmodule