module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

// Round up to next power of two for simplicity: 128
localparam N = 128;

// Pad inputs with 1's for AND, 0's for OR and XOR for missing bits (from 100 to 128)
wire [N-1:0] and_in;
wire [N-1:0] or_in;
wire [N-1:0] xor_in;

genvar i;
// Padding and input assignment
generate
    for (i = 0; i < N; i = i + 1) begin : pad_inputs
        assign and_in[i] = (i < 100) ? in[i] : 1'b1; // padding with 1 for AND
        assign or_in[i]  = (i < 100) ? in[i] : 1'b0; // padding with 0 for OR
        assign xor_in[i] = (i < 100) ? in[i] : 1'b0; // padding with 0 for XOR
    end
endgenerate

// Function to build binary reduction tree for AND
function [N-1:0] and_stage;
    input [N-1:0] data_in;
    input integer width;
    integer j;
    reg [N-1:0] tmp;
    begin
        for (j = 0; j < width/2; j = j + 1)
            tmp[j] = data_in[2*j] & data_in[2*j+1];
        if (width % 2 == 1)
            tmp[width/2] = data_in[width-1];
        and_stage = tmp;
    end
endfunction

// Function to build binary reduction tree for OR
function [N-1:0] or_stage;
    input [N-1:0] data_in;
    input integer width;
    integer j;
    reg [N-1:0] tmp;
    begin
        for (j = 0; j < width/2; j = j + 1)
            tmp[j] = data_in[2*j] | data_in[2*j+1];
        if (width % 2 == 1)
            tmp[width/2] = data_in[width-1];
        or_stage = tmp;
    end
endfunction

// Function to build binary reduction tree for XOR
function [N-1:0] xor_stage;
    input [N-1:0] data_in;
    input integer width;
    integer j;
    reg [N-1:0] tmp;
    begin
        for (j = 0; j < width/2; j = j + 1)
            tmp[j] = data_in[2*j] ^ data_in[2*j+1];
        if (width % 2 == 1)
            tmp[width/2] = data_in[width-1];
        xor_stage = tmp;
    end
endfunction

// We'll iteratively reduce width from 128 to 1
integer width_and, width_or, width_xor;
reg [N-1:0] and_level [0:7]; // max 7 reduction stages for 128 inputs
reg [N-1:0] or_level  [0:7];
reg [N-1:0] xor_level [0:7];

integer stage;

always @* begin
    // Initialize input stage
    and_level[0] = and_in;
    or_level[0]  = or_in;
    xor_level[0] = xor_in;

    width_and = N;
    width_or  = N;
    width_xor = N;

    // Reduce AND tree
    for (stage = 1; stage <= 7; stage = stage + 1) begin
        and_level[stage] = and_stage(and_level[stage-1], width_and);
        if (width_and == 1)
            width_and = 1;
        else
            width_and = (width_and + 1) >> 1;
    end

    // Reduce OR tree
    for (stage = 1; stage <= 7; stage = stage + 1) begin
        or_level[stage] = or_stage(or_level[stage-1], width_or);
        if (width_or == 1)
            width_or = 1;
        else
            width_or = (width_or + 1) >> 1;
    end

    // Reduce XOR tree
    for (stage = 1; stage <= 7; stage = stage + 1) begin
        xor_level[stage] = xor_stage(xor_level[stage-1], width_xor);
        if (width_xor == 1)
            width_xor = 1;
        else
            width_xor = (width_xor + 1) >> 1;
    end
end

assign out_and = and_level[7][0];
assign out_or  = or_level[7][0];
assign out_xor = xor_level[7][0];

endmodule