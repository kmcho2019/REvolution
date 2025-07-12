module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            // Direct done assignment when third byte is received
            done <= (cnt == 2'b10);
            
            // Simplified counter logic with conditional counting
            case (cnt)
                2'b00: cnt <= in[3] ? 2'b01 : 2'b00;  // Start counting only if in[3]=1
                2'b10: cnt <= 2'b00;                   // Wrap around after third byte
                default: cnt <= cnt + 1'b1;            // Increment otherwise
            endcase
        end
    end

endmodule