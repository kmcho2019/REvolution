module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] history;

    // Shift register to track last 7 bits
    always @(posedge clk) begin
        if (reset) begin
            history <= 7'b0;
        end else begin
            history <= {history[5:0], in};
        end
    end

    // Pattern detection (combinational)
    wire five_ones_zero = (history[5:0] == 6'b111110) && (in == 0);
    wire six_ones_zero = (history == 7'b1111110);
    wire seven_ones = (history == 7'b1111111) && in;

    // Output registration (meets timing requirement)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= five_ones_zero;
            flag <= six_ones_zero;
            err <= seven_ones;
        end
    end

endmodule