module TopModule (
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

always @(*) begin
    // Default outputs
    Y1 = 1'b0;
    Y3 = 1'b0;

    // Y1 is set when transitioning from A (y[0]) to B on w=1
    if ((y[0] == 1'b1) && (w == 1'b1)) begin
        Y1 = 1'b1;
    end

    // Y3 is set when transitioning to D (y[3]) from B, C, E, F on w=0
    if (((y[1] == 1'b1) || (y[2] == 1'b1) || (y[4] == 1'b1) || (y[5] == 1'b1)) && (w == 1'b0)) begin
        Y3 = 1'b1;
    end
end

endmodule