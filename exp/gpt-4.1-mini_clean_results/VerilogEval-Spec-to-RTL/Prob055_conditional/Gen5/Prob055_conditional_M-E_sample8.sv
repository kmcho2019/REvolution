module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    // Array to hold inputs for easy iteration
    reg [7:0] inputs [0:3];
    integer i;

    always @* begin
        inputs[0] = a;
        inputs[1] = b;
        inputs[2] = c;
        inputs[3] = d;

        min = inputs[0]; // Initialize min with the first input
        for (i = 1; i < 4; i = i + 1) begin
            if (inputs[i] < min)
                min = inputs[i];
        end
    end

endmodule