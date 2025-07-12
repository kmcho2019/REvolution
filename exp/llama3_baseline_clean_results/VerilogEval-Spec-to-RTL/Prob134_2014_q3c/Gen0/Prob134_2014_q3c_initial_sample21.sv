module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] Y;

always @(*) begin
    case ({y[2], y[1], y[0]})
        3'b000: begin
            if (~x) Y = 3'b000;
            else Y = 3'b001;
            z = 1'b0;
        end
        3'b001: begin
            if (~x) Y = 3'b001;
            else Y = 3'b100;
            z = 1'b0;
        end
        3'b010: begin
            if (~x) Y = 3'b010;
            else Y = 3'b001;
            z = 1'b0;
        end
        3'b011: begin
            if (~x) Y = 3'b001;
            else Y = 3'b010;
            z = 1'b1;
        end
        3'b100: begin
            if (~x) Y = 3'b011;
            else Y = 3'b100;
            z = 1'b1;
        end
        default: begin
            Y = 3'b000;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    Y0 = Y[0];
end

endmodule