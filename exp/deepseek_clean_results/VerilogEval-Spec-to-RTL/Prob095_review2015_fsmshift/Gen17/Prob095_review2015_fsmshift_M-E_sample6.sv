module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;
    reg active;

    assign shift_ena = active && (counter != 2'b00);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11;
            active <= 1'b1;
        end else if (active) begin
            if (counter == 2'b00) begin
                active <= 1'b0;
            end else begin
                counter <= counter - 1'b1;
            end
        end
    end

endmodule