module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] next_state;
    reg z_reg;

    always @(*) begin
        case (y)
            3'b000: begin
                // next_state: x=0 -> 000, x=1 -> 001; z=0
                if (x)
                    next_state = 3'b001;
                else
                    next_state = 3'b000;
                z_reg = 1'b0;
            end
            3'b001: begin
                // next_state: x=0 -> 001, x=1 -> 100; z=0
                if (x)
                    next_state = 3'b100;
                else
                    next_state = 3'b001;
                z_reg = 1'b0;
            end
            3'b010: begin
                // next_state: x=0 -> 010, x=1 -> 001; z=0
                if (x)
                    next_state = 3'b001;
                else
                    next_state = 3'b010;
                z_reg = 1'b0;
            end
            3'b011: begin
                // next_state: x=0 -> 001, x=1 -> 010; z=1
                if (x)
                    next_state = 3'b010;
                else
                    next_state = 3'b001;
                z_reg = 1'b1;
            end
            3'b100: begin
                // next_state: x=0 -> 011, x=1 -> 100; z=1
                if (x)
                    next_state = 3'b100;
                else
                    next_state = 3'b011;
                z_reg = 1'b1;
            end
            default: begin
                // Default safe state: hold at 000, z=0
                next_state = 3'b000;
                z_reg = 1'b0;
            end
        endcase
    end

    assign Y0 = next_state[0];
    assign z = z_reg;

endmodule