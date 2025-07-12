module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] Q;

    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    wire [2:0] sel = {A, B, C};
    assign Z = Q[sel];

endmodule