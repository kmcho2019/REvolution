module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Define the tap positions
localparam TAP_32 = 31;
localparam TAP_22 = 21;
localparam TAP_2  = 1;
localparam TAP_1  = 0;

// Define the XOR module
module xor_module(
    input [3:0] a,
    output reg  y
);
    always @(*) begin
        y = a[0] ^ a[1] ^ a[2] ^ a[3];
    end
endmodule

// Define the barrel shifter module
module barrel_shifter(
    input [31:0] a,
    output reg [31:0] y
);
    always @(*) begin
        y = {a[0], a[31:1]};
    end
endmodule

// Define the LFSR module
module lfsr_module(
    input [31:0] a,
    output reg [31:0] y
);
    reg [3:0] tapped_bits;
    reg        xor_result;
    wire [31:0] shifted_bits;

    // Instantiate the XOR module
    xor_module u_xor_module(
       .a({q[TAP_1], q[TAP_2], q[TAP_22], q[TAP_32]}),
       .y(xor_result)
    );

    // Instantiate the barrel shifter module
    barrel_shifter u_barrel_shifter(
       .a(a),
       .y(shifted_bits)
    );

    // Apply the XOR operation to the tapped positions
    always @(*) begin
        y = {xor_result, shifted_bits[31:1]};
    end
endmodule

// Instantiate the LFSR module
lfsr_module u_lfsr_module(
   .a(q),
   .y(q)
);

// Handle the reset
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {q[0] ^ q[31] ^ q[21] ^ q[1], q[31:1]};
    end
end

endmodule