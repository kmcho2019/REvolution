module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;
    reg counting;  // State flag to indicate if we're still counting

    assign shift_ena = counting;  // Active while counting (for 4 cycles)

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            counting <= 1'b1;
        end else if (counting) begin
            if (counter == 2'b11) begin
                counting <= 1'b0;  // Stop counting after 4 cycles
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule