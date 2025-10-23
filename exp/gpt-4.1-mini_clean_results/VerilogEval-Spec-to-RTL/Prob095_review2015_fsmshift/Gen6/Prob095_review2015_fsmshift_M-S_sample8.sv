module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'd0;
        end else if (counter != 2'd3) begin
            counter <= counter + 1;
        end
    end

    assign shift_ena = (counter <= 2'd3);

endmodule