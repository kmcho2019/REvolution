module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output reg p1y,
    output reg p2y
);

    wire [3:0] p1_inputs;
    wire [3:0] p2_inputs;

    assign p1_inputs = {p1a, p1b, p1c, p1d};
    assign p2_inputs = {p2a, p2b, p2c, p2d};

    reg p1_and;
    reg p2_and;

    integer i;

    always @(*) begin
        p1_and = 1'b1;
        for(i=0; i<4; i=i+1) begin
            p1_and = p1_and & p1_inputs[i];
        end
        p1y = ~p1_and;
    end

    always @(*) begin
        p2_and = 1'b1;
        for(i=0; i<4; i=i+1) begin
            p2_and = p2_and & p2_inputs[i];
        end
        p2y = ~p2_and;
    end

endmodule