module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            shift_ena <= 1'b1;
        end else begin
            if (shift_ena) begin
                counter <= counter + 1;
                if (counter == 2'b11) begin
                    shift_ena <= 1'b0;
                end
            end
        end
    end

endmodule