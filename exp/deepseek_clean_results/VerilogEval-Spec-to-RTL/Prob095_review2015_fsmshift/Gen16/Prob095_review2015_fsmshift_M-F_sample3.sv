module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] counter;  // 2 bits sufficient for 0-3 count
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            shift_ena <= 1'b1;
        end else begin
            if (counter < 2'b11) begin
                counter <= counter + 1;
            end
            shift_ena <= (counter < 2'b11);
        end
    end

endmodule