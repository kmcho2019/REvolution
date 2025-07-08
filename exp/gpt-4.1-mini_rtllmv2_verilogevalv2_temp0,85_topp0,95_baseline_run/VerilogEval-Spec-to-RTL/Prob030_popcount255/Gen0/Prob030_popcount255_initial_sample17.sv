module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Sum bits by using a for loop to count number of ones
    integer i;
    reg [8:0] count; // 9 bits to hold counts up to 255

    always @(*) begin
        count = 0;
        for (i = 0; i < 255; i = i + 1) begin
            count = count + in[i];
        end
    end

    assign out = count[7:0];

endmodule