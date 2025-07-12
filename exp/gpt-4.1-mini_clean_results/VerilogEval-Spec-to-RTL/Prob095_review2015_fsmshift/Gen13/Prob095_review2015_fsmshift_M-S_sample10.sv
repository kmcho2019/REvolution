module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
        end else if (count < 2'd4) begin
            count <= count + 1;
        end
    end

    assign shift_ena = (count < 2'd4);

endmodule