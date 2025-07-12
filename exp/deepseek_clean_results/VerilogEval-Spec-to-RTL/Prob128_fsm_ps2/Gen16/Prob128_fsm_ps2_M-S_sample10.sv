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
            done <= (count == 2'b10);  // Assert done when count==2
            
            if (count == 2'b00) begin
                if (in[3]) count <= 2'b01;  // Start counting
            end else begin
                count <= count + 1;  // Simple increment with wrap-around
            end
        end
    end

endmodule