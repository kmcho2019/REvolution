module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Define state encodings as localparams for clarity
    localparam [2:0]
        S000 = 3'b000,
        S001 = 3'b001,
        S010 = 3'b010,
        S011 = 3'b011,
        S100 = 3'b100;

    reg [2:0] next_state;
    reg       z_reg;

    always @(*) begin
        case (y)
            S000: begin
                if (x == 1'b0)
                    next_state = S000;
                else
                    next_state = S001;
                z_reg = 1'b0;
            end
            S001: begin
                if (x == 1'b0)
                    next_state = S001;
                else
                    next_state = S100;
                z_reg = 1'b0;
            end
            S010: begin
                if (x == 1'b0)
                    next_state = S010;
                else
                    next_state = S001;
                z_reg = 1'b0;
            end
            S011: begin
                if (x == 1'b0)
                    next_state = S001;
                else
                    next_state = S010;
                z_reg = 1'b1;
            end
            S100: begin
                if (x == 1'b0)
                    next_state = S011;
                else
                    next_state = S100;
                z_reg = 1'b1;
            end
            default: begin
                // If y is out of defined states, default to S000
                next_state = S000;
                z_reg = 1'b0;
            end
        endcase
    end

    // Y0 is the LSB of the next state
    assign Y0 = next_state[0];
    assign z = z_reg;

endmodule