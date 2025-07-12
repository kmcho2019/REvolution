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

    // Shift register update on positive clock edge when enabled
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Multiplexer selecting output Z based on {A,B,C}
    assign Z = Q[{A,B,C}];

endmodule