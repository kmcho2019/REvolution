module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    wire [29:0] input_array [5:0];
    wire [31:0] output_vector;

    assign input_array[0] = a;
    assign input_array[1] = b;
    assign input_array[2] = c;
    assign input_array[3] = d;
    assign input_array[4] = e;
    assign input_array[5] = f;

    reg [29:0] temp;
    integer i;

    always @(*) begin
        temp = 30'd0;
        for (i = 0; i < 6; i++) begin
            temp = {temp[24:0], input_array[i]};
        end
        output_vector = {temp, 2'b11};
    end

    assign w = output_vector[31:24];
    assign x = output_vector[23:16];
    assign y = output_vector[15:8];
    assign z = output_vector[7:0];

endmodule