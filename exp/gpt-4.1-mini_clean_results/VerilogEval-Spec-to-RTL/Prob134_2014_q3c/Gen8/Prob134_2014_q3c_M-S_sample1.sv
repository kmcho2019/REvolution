module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] next_state;

    always @(*) begin
        if (y == 3'b000) next_state = (x == 1'b0) ? 3'b000 : 3'b001;
        else if (y == 3'b001) next_state = (x == 1'b0) ? 3'b001 : 3'b100;
        else if (y == 3'b010) next_state = (x == 1'b0) ? 3'b010 : 3'b001;
        else if (y == 3'b011) next_state = (x == 1'b0) ? 3'b001 : 3'b010;
        else if (y == 3'b100) next_state = (x == 1'b0) ? 3'b011 : 3'b100;
        else next_state = 3'b000; // safe default for undefined states
    end

    assign Y0 = next_state[0];
    assign z  = (y == 3'b011) || (y == 3'b100);

endmodule