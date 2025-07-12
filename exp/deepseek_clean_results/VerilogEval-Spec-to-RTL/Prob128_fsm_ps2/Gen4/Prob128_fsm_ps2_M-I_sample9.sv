module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [2:0] state;  // One-hot encoding: [0]=waiting, [1]=byte1, [2]=byte2

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b001;  // Reset to waiting state
            done <= 1'b0;
        end else begin
            // Clear done unless we're completing a message
            if (state == 3'b100) begin
                done <= 1'b1;
                state <= 3'b001;  // Return to waiting state
            end else begin
                done <= 1'b0;
                
                // State transition logic
                case (state)
                    3'b001: if (in[3]) state <= 3'b010;  // Waiting -> Byte1
                    3'b010: state <= 3'b100;              // Byte1 -> Byte2
                    default: state <= state;              // Hold current state
                endcase
            end
        end
    end

endmodule