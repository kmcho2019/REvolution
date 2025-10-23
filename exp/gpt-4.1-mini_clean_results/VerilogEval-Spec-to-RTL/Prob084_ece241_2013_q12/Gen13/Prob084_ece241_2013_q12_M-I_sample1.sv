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

    // Shift register with synchronous enable and positive-edge clock
    always @(posedge clk) begin
        if (enable) begin
            Q <= {S, Q[7:1]}; // Shift right with MSB shifted in from S
        end
    end

    // Combinational multiplexer selecting output bit indexed by ABC
    assign Z = Q[{A, B, C}];

endmodule