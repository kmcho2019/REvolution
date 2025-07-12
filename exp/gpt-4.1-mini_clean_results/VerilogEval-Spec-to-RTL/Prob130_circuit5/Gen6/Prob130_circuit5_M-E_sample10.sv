module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Define a small combinational ROM implemented as a constant array
    reg [3:0] rom [0:15];
    integer i;

    // Initialize ROM contents combinationally
    always @(*) begin
        // Default all entries to 4'hF
        for (i = 0; i < 16; i = i + 1)
            rom[i] = 4'hF;

        // Override the specific entries as per c value
        rom[4'd0] = b;
        rom[4'd1] = e;
        rom[4'd2] = a;
        rom[4'd3] = d;
    end

    // Assign output as ROM content indexed by c
    assign q = rom[c];

endmodule