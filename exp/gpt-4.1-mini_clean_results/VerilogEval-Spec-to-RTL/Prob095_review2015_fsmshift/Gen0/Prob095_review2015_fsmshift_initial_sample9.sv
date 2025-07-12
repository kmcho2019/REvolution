module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, start counting and enable shift_ena
            count <= 3'd0;
            shift_ena <= 1'b1;
        end else begin
            if (count < 3'd3) begin
                // Count up to 3, keeping shift_ena high (4 cycles: count=0,1,2,3)
                count <= count + 1'b1;
                shift_ena <= 1'b1;
            end else begin
                // After 4 cycles, disable shift_ena forever
                shift_ena <= 1'b0;
                count <= count; // hold count
            end
        end
    end

endmodule