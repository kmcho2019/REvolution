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

    // Shift register: on posedge clk, if enable shift right and load S into Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // shift right, MSB shifted in first at Q[0]
        end
    end

    // Multiplexer select based on ABC
    wire [2:0] select = {A, B, C};

    // Assign output Z based on select indexing Q
    assign Z = Q[select];

endmodule