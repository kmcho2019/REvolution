module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= (count == 2'b10);  // Assert done after 3rd byte
            
            if (count == 2'b00) begin
                if (in[3]) count <= 2'b01;  // Start new message
            end else begin
                count <= count + 1;  // Increment byte count
            end
        end
    end

endmodule