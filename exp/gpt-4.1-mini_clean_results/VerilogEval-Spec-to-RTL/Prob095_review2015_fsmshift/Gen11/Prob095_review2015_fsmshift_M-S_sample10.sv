module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
        end else if (counter < 3'd4) begin
            counter <= counter + 1;
        end
    end

    assign shift_ena = (counter < 3'd4);

endmodule