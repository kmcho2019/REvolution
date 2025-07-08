module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // Shift register logic
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift right: shift in S at Q[0]
        end
    end

    // 3-bit select from A,B,C to pick Q[i]
    wire [2:0] sel = {A,B,C};

    // Multiplexer to select Q[sel] for output Z
    assign Z = Q[sel];

endmodule