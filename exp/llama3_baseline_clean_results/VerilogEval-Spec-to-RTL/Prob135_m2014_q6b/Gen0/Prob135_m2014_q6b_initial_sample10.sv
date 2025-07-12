module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b101) || (y == 3'b110) || 
                     ((y == 3'b011 || y == 3'b100) && w);

    // To demonstrate next-state logic
    reg [2:0] y_reg;
    initial y_reg = 3'b000;

    always @(posedge w) begin
        if (y == 3'b101 || y == 3'b110 || ((y == 3'b011 || y == 3'b100) && w)) begin
            y_reg[1] <= 1'b1;
        end else begin
            y_reg[1] <= 1'b0;
        end
    end

endmodule