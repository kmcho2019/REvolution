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
            done <= 1'b0;
            
            if (count == 2'b00) begin
                if (in[3]) begin
                    count <= 2'b01;  // First byte of message
                end
            end else begin
                if (count == 2'b10) begin
                    done <= 1'b1;    // Assert done after 3rd byte
                    count <= 2'b00; // Reset for next message
                end else begin
                    count <= count + 1; // Increment byte counter
                end
            end
        end
    end

endmodule