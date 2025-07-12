module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] base_pattern = {4'b0001, 4'b0010, 4'b0011, 4'b0010};
wire [15:0] xor_mask = {4'b1010, 4'b1110, 4'b1110, 4'b0000};
wire [15:0] shift_mask = {4'b0001, 4'b0001, 4'b0001, 4'b0001};

wire [15:0] pattern = base_pattern ^ (xor_mask & {16{a[0]}});
wire [15:0] shifted = pattern << a;
wire [15:0] rotated = {shifted[7:0], shifted[15:8]};

assign q = rotated ^ (16'h1111 & {16{a[1]}}) ^ (16'hAAAA & {16{a[2]}});

endmodule