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
            // Default assignments
            done <= 1'b0;
            
            if (shift == 2'b00) begin
                // Only check in[3] when not in message (power optimization)
                if (in[3]) begin
                    shift <= 2'b01;  // Start new message
                end
            end else begin
                // Shift left and clear LSB (simpler than counter)
                shift <= {shift[0], 1'b0};
                // Assert done after third byte (shift == 2'b10)
                done <= (shift == 2'b01);  // Registered one cycle after third byte
            end
        end
    end

endmodule