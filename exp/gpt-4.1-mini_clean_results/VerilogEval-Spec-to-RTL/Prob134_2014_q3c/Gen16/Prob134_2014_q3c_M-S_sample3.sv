module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state bits directly encoded from present state y and input x

    // ns2 = (y==3'b001 && x==1) || (y==3'b100 && x==1)
    wire ns2 = ((y == 3'b001) | (y == 3'b100)) & x;

    // ns1 = (y==3'b010 && x==0) || (y==3'b011 && x==1) || (y==3'b100 && x==0)
    wire ns1 = ((y == 3'b010) & ~x) | ((y == 3'b011) & x) | ((y == 3'b100) & ~x);

    // ns0 logic from table:
    // For y in {000,010}: ns0 = x; else ns0 = ~x
    wire y_is_000_or_010 = (y == 3'b000) | (y == 3'b010);
    wire ns0 = y_is_000_or_010 ? x : ~x;

    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z=1 when y=011 or y=100
    wire z_int = (y == 3'b011) | (y == 3'b100);

    assign Y0 = next_state[0];
    assign z = z_int;

endmodule