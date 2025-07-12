module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset)
            counter <= 2'b00;
        else if (counter < 2'b11)
            counter <= counter + 1;
    end

    assign shift_ena = (counter < 2'b11);

endmodule