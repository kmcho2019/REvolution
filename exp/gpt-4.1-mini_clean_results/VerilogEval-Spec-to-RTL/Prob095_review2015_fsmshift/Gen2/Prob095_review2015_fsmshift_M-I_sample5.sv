module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            shift_ena <= 1'b1;  // Enable on reset cycle
        end else if (count < 3'd4) begin
            count <= count + 1;
            shift_ena <= 1'b1;  // Enable for counts 0,1,2,3 (4 cycles total)
        end else begin
            shift_ena <= 1'b0;  // Disable after 4 cycles
        end
    end

endmodule