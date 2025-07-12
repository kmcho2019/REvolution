module TopModule(
    input [2:0] in,
    output [1:0] out
);

    reg [1:0] temp_out;

    always @(*)
    begin
        // Calculate the population count directly
        temp_out = in[0] + in[1] + in[2];
    end

    assign out = temp_out;

endmodule