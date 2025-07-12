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

    // Shift register logic
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Multiplexer select from ABC
    wire [2:0] sel = {A,B,C};

    // 8-to-1 mux output
    assign Z = Q[sel];

endmodule