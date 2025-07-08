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
            Q <= {Q[6:0], S}; // Shift left: MSB shifted in at Q[0]
        end
    end

    // Multiplexer to select Q based on ABC
    wire [2:0] addr = {A,B,C};

    assign Z = Q[addr];

endmodule