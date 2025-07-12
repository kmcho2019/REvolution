module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] shift;

    always @(posedge clk) begin
        if (reset) begin
            shift <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= (shift == 2'b10);  // Assert done after 3rd byte
            
            if (shift == 2'b00) begin
                if (in[3]) shift <= 2'b01;  // Start new message
            end else begin
                shift <= {shift[0], 1'b0};  // Shift left and clear LSB
            end
        end
    end

endmodule