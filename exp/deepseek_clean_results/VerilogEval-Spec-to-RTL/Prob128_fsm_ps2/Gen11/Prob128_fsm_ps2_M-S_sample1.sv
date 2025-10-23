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
            
            if (in[3] && (count == 2'b00)) begin
                count <= 2'b01;  // Start new message
            end else if (count != 2'b00) begin
                count <= count + 1;  // Increment counter
            end
        end
    end

endmodule