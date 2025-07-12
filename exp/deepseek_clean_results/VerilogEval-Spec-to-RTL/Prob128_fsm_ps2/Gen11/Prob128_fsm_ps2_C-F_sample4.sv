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
            done <= (state == 2'b10);  // Assert done after 3rd byte
            
            case (state)
                2'b00: if (in[3]) state <= 2'b01;  // Wait for start byte
                2'b01: state <= 2'b10;             // Second byte
                2'b10: state <= 2'b00;             // Third byte - wrap around
                default: state <= 2'b00;            // Handle unexpected states
            endcase
        end
    end

endmodule