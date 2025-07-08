module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] count;  // 2-bit counter to count 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b00;
            shift_ena <= 1'b1;  // start asserting on reset
        end else if (shift_ena) begin
            if (count == 2'b11) begin
                shift_ena <= 1'b0;  // stop after 4 cycles
            end else begin
                count <= count + 1;
            end
        end else begin
            // shift_ena is 0 and stays 0
            count <= count;
            shift_ena <= shift_ena;
        end
    end

endmodule