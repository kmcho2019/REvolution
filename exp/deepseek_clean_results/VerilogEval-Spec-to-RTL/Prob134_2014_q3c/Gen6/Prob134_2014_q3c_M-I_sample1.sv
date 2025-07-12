module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Combined next state and output logic
    reg [2:0] Y;
    always @(*) begin
        case (y)
            3'b000: begin Y = x ? 3'b001 : 3'b000; end
            3'b001: begin Y = x ? 3'b100 : 3'b001; end
            3'b010: begin Y = x ? 3'b001 : 3'b010; end
            3'b011: begin Y = x ? 3'b010 : 3'b001; end
            3'b100: begin Y = x ? 3'b100 : 3'b011; end
        endcase
    end

    // Direct output assignments
    assign z = (y == 3'b011) || (y == 3'b100);
    assign Y0 = Y[0];

endmodule