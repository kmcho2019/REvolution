module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state and output logic
    reg [2:0] Y;
    reg z_out;

    always @(*) begin
        case (y)
            3'b000: begin
                Y = x ? 3'b001 : 3'b000;
                z_out = 1'b0;
            end
            3'b001: begin
                Y = x ? 3'b100 : 3'b001;
                z_out = 1'b0;
            end
            3'b010: begin
                Y = x ? 3'b001 : 3'b010;
                z_out = 1'b0;
            end
            3'b011: begin
                Y = x ? 3'b010 : 3'b001;
                z_out = 1'b1;
            end
            3'b100: begin
                Y = x ? 3'b100 : 3'b011;
                z_out = 1'b1;
            end
            default: begin  // Handle undefined states (shouldn't occur)
                Y = 3'b000;
                z_out = 1'b0;
            end
        endcase
    end

    assign z = z_out;
    assign Y0 = Y[0];

endmodule