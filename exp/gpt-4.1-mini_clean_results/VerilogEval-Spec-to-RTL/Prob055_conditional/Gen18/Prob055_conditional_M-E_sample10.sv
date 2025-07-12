module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    integer i;
    reg [7:0] candidates [0:3];
    reg [7:0] current_min;

    always @(*) begin
        candidates[0] = a;
        candidates[1] = b;
        candidates[2] = c;
        candidates[3] = d;

        current_min = candidates[0];
        for (i = 1; i < 4; i = i + 1) begin
            if (candidates[i] < current_min)
                current_min = candidates[i];
        end
        min = current_min;
    end
endmodule