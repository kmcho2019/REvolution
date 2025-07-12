module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [2:0] state;  // One-hot encoded: 001=wait, 010=byte1, 100=byte2
    reg in3_reg;
    wire cnt_en = (state != 3'b001) || in[3];  // Only enable during message or start

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b001;  // Initial wait state
            done <= 1'b0;
            in3_reg <= 1'b0;
        end else begin
            in3_reg <= in[3];  // Register in[3] to break timing path
            
            // Only update done when we're completing a message
            done <= (state == 3'b100) && cnt_en;
            
            if (cnt_en) begin
                case (state)
                    3'b001: state <= 3'b010;  // Start new message
                    3'b010: state <= 3'b100;  // Second byte
                    3'b100: state <= 3'b001;  // Third byte, return to wait
                    default: state <= 3'b001;
                endcase
            end
        end
    end

endmodule