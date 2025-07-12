module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [3:0] count;
    reg receiving;

    always @(posedge clk) begin
        if (reset) begin
            receiving <= 1'b0;
            count <= 4'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (receiving) begin
                if (count == 4'd8) begin
                    if (in) begin  // Valid stop bit
                        done <= 1'b1;
                        receiving <= 1'b0;
                    end
                    count <= 4'b0;
                end else begin
                    count <= count + 1;
                    // Error recovery: if we see start bit during reception
                    if (in == 1'b0 && count != 4'd0) begin
                        count <= 4'b1;  // Restart counting
                    end
                end
            end else if (in == 1'b0) begin  // Start bit detected
                receiving <= 1'b1;
                count <= 4'b0;
            end
        end
    end

endmodule