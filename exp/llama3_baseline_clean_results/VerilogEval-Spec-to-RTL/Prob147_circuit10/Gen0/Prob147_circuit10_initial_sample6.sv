module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    always @(posedge clk) begin
        if (a && b) begin
            state <= ~state;
        end
    end

    assign q = (~state && b);

endmodule