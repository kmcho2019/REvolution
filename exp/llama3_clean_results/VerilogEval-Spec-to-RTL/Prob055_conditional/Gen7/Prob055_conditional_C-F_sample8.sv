module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    reg [7:0] ab_min, ab_max;
    reg [7:0] cd_min, cd_max;
    reg [7:0] min_reg;

    always @(*) begin
        // Compare and swap a and b
        ab_min = (a < b)? a : b;
        ab_max = (a < b)? b : a;

        // Compare and swap c and d
        cd_min = (c < d)? c : d;
        cd_max = (c < d)? d : c;

        // Compare and swap ab_min and cd_min
        min_reg = (ab_min < cd_min)? ab_min : cd_min;
    end

    assign min = min_reg;

endmodule