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

    // Shift register: on posedge clk, if enable shift in S to Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {S, Q[7:1]};
        end
    end

    // Multiplexer for random access read based on ABC
    wire [2:0] addr = {A, B, C};
    assign Z = Q[addr];

endmodule