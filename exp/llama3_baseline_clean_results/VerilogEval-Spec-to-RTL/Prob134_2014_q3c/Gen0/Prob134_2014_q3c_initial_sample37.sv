module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] Y;

always @(posedge clk)
    Y <= (x == 0) ? ({y[2], y[1], y[0]}) : ({y[2], y[1], y[0]} + 1'b1);

always @(*)
begin
    case (Y)
        3'b000: begin
            if (x == 0)
                Y0 = 0;
            else
                Y0 = 1;
            z = 0;
        end
        3'b001: begin
            Y0 = (x == 0) ? 0 : 1;
            z = 0;
        end
        3'b010: begin
            Y0 = (x == 0) ? 0 : 0;
            z = 0;
        end
        3'b011: begin
            if (x == 0)
                Y0 = 0;
            else
                Y0 = 0;
            z = 1;
        end
        3'b100: begin
            Y0 = (x == 0) ? 0 : 1;
            z = 1;
        end
    endcase
end

endmodule