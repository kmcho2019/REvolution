module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] Y_next;
    reg       z_reg;

    // Next state and output logic combinational
    always @(*) begin
        case (y)
            3'b000: begin
                Y_next = (x == 1'b0) ? 3'b000 : 3'b001;
                z_reg = 1'b0;
            end
            3'b001: begin
                Y_next = (x == 1'b0) ? 3'b001 : 3'b100;
                z_reg = 1'b0;
            end
            3'b010: begin
                Y_next = (x == 1'b0) ? 3'b010 : 3'b001;
                z_reg = 1'b0;
            end
            3'b011: begin
                Y_next = (x == 1'b0) ? 3'b001 : 3'b010;
                z_reg = 1'b1;
            end
            3'b100: begin
                Y_next = (x == 1'b0) ? 3'b011 : 3'b100;
                z_reg = 1'b1;
            end
            default: begin
                Y_next = 3'b000;
                z_reg = 1'b0;
            end
        endcase
    end

    // Output assignments
    assign Y0 = Y_next[0];
    assign z  = z_reg;

endmodule