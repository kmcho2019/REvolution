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
    reg [2:0] index_reg;

    // Shift register with synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Register selector inputs to reduce glitches and improve timing
    always @(posedge clk) begin
        index_reg <= {A, B, C};
    end

    // Multiplexer output: select Q bit indexed by registered selector inputs
    assign Z = Q[index_reg];

endmodule