module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);
    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        // Y1: next state B input
        if (y[0] && w) begin
            Y1 = 1'b1;
        end

        // Y3: next state D input
        if (~w && (y[1] || y[2] || y[4] || y[5])) begin
            Y3 = 1'b1;
        end
    end

endmodule