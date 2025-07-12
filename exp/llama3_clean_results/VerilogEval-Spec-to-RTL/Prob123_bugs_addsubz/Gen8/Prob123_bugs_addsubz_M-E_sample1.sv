// Define the LUT for addition
reg [7:0] add_lut [256*256];

// Initialize the LUT
initial begin
    for (int i = 0; i < 256; i++) begin
        for (int j = 0; j < 256; j++) begin
            add_lut[i*256 + j] = i + j;
        end
    end
end

// Define the LUT for subtraction
reg [7:0] sub_lut [256*256];

// Initialize the LUT
initial begin
    for (int i = 0; i < 256; i++) begin
        for (int j = 0; j < 256; j++) begin
            sub_lut[i*256 + j] = i - j;
        end
    end
end

// Top-level module
module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Perform addition or subtraction based on control signal
    always @(*) begin
        if (do_sub) begin
            out = sub_lut[a*256 + b];
        end else begin
            out = add_lut[a*256 + b];
        end
    end

    // Generate zero flag using bitwise operation
    assign result_is_zero = ~(| out);

endmodule