module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic
    reg [2:0] Y;
    reg z_out;

    always @(*) begin
        case (y)
            3'b000: begin Y = {2'b00, x}; z_out = 1'b0; end
            3'b001: begin Y = {x, 2'b00}; z_out = 1'b0; end
            3'b010: begin Y = {2'b01, ~x}; z_out = 1'b0; end
            3'b011: begin Y = {1'b0, x, ~x}; z_out = 1'b1; end
            3'b100: begin Y = {1'b0, ~x, x}; z_out = 1'b1; end
        endcase
    end

    assign z = z_out;
    assign Y0 = Y[0];

endmodule