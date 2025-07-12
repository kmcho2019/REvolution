module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] counter;
reg phase;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        phase <= 1'b0;
    end else begin
        if (counter == (phase ? 3'd2 : 3'd3)) begin
            clk_div <= 1'b0;
            if (counter == 3'd6) begin
                counter <= 3'b0;
                phase <= ~phase;
            end else begin
                counter <= counter + 1'b1;
            end
        end else if (counter == 3'd0) begin
            clk_div <= 1'b1;
            counter <= counter + 1'b1;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

endmodule