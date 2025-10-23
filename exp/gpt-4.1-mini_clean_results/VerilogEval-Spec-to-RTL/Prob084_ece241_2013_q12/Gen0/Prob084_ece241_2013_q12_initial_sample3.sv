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

    // Shift register with synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Multiplexer: index formed by ABC selects Q bit
    wire [2:0] index;
    assign index = {A, B, C};

    // Output Z is selected bit from Q
    assign Z = Q[index];

endmodule