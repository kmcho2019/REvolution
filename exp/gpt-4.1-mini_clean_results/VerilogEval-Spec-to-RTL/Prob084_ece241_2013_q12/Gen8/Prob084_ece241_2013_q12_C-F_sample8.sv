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

    // Shift register with synchronous enable; MSB shifted in first means S goes into Q[0], shifting towards Q[7]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Select signal combined
    wire [2:0] sel = {A, B, C};

    // Output assigned directly from Q indexed by sel for minimal combinational logic depth
    assign Z = Q[sel];

endmodule