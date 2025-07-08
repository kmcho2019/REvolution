module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] y_reg;
    reg [2:0] Y_next;
    reg z_reg;

    // Next state and output logic
    always @(*) begin
        case (y_reg)
            3'b000: begin
                if (x == 0) Y_next = 3'b000;
                else        Y_next = 3'b001;
                z_reg = 1'b0;
            end
            3'b001: begin
                if (x == 0) Y_next = 3'b001;
                else        Y_next = 3'b100;
                z_reg = 1'b0;
            end
            3'b010: begin
                if (x == 0) Y_next = 3'b010;
                else        Y_next = 3'b001;
                z_reg = 1'b0;
            end
            3'b011: begin
                if (x == 0) Y_next = 3'b001;
                else        Y_next = 3'b010;
                z_reg = 1'b1;
            end
            3'b100: begin
                if (x == 0) Y_next = 3'b011;
                else        Y_next = 3'b100;
                z_reg = 1'b1;
            end
            default: begin
                // Undefined states go to 000 by default
                Y_next = 3'b000;
                z_reg = 1'b0;
            end
        endcase
    end

    // State register update on clock edge
    always @(posedge clk) begin
        y_reg <= Y_next;
    end

    assign Y0 = Y_next[0];
    assign z = z_reg;

endmodule