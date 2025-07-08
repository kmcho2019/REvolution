module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg [1:0] state;

    always @(posedge clock) begin
        if (a)
            state <= state + 1;
        else
            state <= 2'b00;
    end

    always @(*) begin
        p = state[0];
        q = state[1];
    end

endmodule