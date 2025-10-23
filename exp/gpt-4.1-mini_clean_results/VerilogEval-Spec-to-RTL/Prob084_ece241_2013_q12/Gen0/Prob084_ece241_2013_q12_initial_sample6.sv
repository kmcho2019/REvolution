module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    reg [7:0] Q;

    // Shift register logic
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Multiplexer to select one bit based on A,B,C
    wire [2:0] sel = {A, B, C};
    assign Z = Q[sel];

endmodule