module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            if (state == 2'b00) begin
                if (in[3]) begin
                    state <= 2'b01;  // Start new message
                end
            end else begin
                state <= {state[0], 1'b0};  // Shift left and clear LSB
                if (state == 2'b10) begin
                    done <= 1'b1;    // Assert done after 3rd byte
                end
            end
        end
    end

endmodule