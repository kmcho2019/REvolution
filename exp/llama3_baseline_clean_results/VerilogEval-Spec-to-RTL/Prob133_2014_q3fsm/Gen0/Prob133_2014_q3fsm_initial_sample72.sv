module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter; // counter to track clock cycles
reg flag; // flag to track whether condition is met
reg state; // state of the FSM (0: A, 1: B)

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to state A
        counter <= 0; // reset counter
        flag <= 0; // reset flag
        z <= 0; // reset output
    end else begin
        if (state == 0) begin // state A
            if (s) begin
                state <= 1; // move to state B
            end
        end else begin // state B
            counter <= counter + 1; // increment counter
            if (w) begin
                flag <= flag + 1; // increment flag if w = 1
            end
            if (counter == 3) begin // check condition after three clock cycles
                if (flag == 2) begin
                    z <= 1; // set z to 1 if condition is met
                end else begin
                    z <= 0; // set z to 0 if condition is not met
                end
                counter <= 0; // reset counter
                flag <= 0; // reset flag
            end
        end
    end
end

endmodule