module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] history;
    wire five_ones = (history[5:0] == 6'b111110);
    wire six_ones = (history == 7'b1111110);
    wire seven_ones = (history[6:0] == 7'b1111111);

    always @(posedge clk) begin
        if (reset) begin
            history <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Shift in new bit
            history <= {history[5:0], in};

            // Set outputs based on patterns
            disc <= five_ones && !in;
            flag <= six_ones;
            err <= seven_ones;
        end
    end

endmodule