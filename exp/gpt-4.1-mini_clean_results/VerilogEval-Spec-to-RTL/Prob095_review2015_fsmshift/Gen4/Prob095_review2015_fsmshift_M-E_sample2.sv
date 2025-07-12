module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            // On reset assertion, reset counter and assert shift_ena
            count <= 3'd1;
            shift_ena <= 1'b1;
        end else if (count != 3'd0 && count < 3'd4) begin
            // Continue counting shift_ena cycles after reset deasserted
            count <= count + 1;
            shift_ena <= 1'b1;
        end else begin
            // After 4 cycles, disable shift_ena
            count <= 3'd0;
            shift_ena <= 1'b0;
        end
    end

endmodule