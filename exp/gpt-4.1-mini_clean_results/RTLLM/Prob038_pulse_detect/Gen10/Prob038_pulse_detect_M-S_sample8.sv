module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg prev1, prev2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
            data_out <= 1'b0;
        end else begin
            prev2 <= prev1;
            prev1 <= data_in;
            // Detect pulse: prev2=0, prev1=1, data_in=0
            data_out <= (~prev2) & prev1 & (~data_in);
        end
    end

endmodule