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
            // Default done is 0 unless we're at state 2
            done <= (state == 2'b10);
            
            // State transition logic
            if (state == 2'b00) begin
                // Wait for start byte
                if (in[3]) state <= 2'b01;
            end else begin
                // Progress through message bytes
                state <= {state[0], 1'b0};
            end
        end
    end

endmodule