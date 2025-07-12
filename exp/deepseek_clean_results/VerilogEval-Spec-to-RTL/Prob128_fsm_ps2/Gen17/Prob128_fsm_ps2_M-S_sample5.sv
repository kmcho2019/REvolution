module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg state;  // 0: IDLE, 1: COUNTING
    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            count <= 0;
            done <= 0;
        end else begin
            done <= (state && (count == 2));
            
            if (!state) begin
                // IDLE state - wait for start byte
                if (in[3]) begin
                    state <= 1;
                    count <= 0;
                end
            end else begin
                // COUNTING state - track bytes
                if (count == 2) begin
                    // Message complete, return to IDLE
                    state <= 0;
                end
                count <= count + 1;
            end
        end
    end

endmodule