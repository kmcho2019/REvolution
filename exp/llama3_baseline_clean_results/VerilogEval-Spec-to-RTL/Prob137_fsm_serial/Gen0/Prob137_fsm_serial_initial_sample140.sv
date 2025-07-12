module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // Idle, Receive, VerifyStop, Done
reg [2:0] nextState;
reg [3:0] bitCount;
reg [7:0] data;

always @(*) begin
    case (state)
        3'b001: // Idle
            if (!in) begin // start bit detected
                nextState = 3'b010; // move to Receive state
                bitCount = 1;
            end else begin
                nextState = 3'b001; // stay in Idle state
            end
        3'b010: // Receive
            if (bitCount < 8) begin
                nextState = 3'b010; // stay in Receive state
                bitCount = bitCount + 1;
                data = {data[6:0], in}; // shift in the new bit
            end else begin
                nextState = 3'b100; // move to VerifyStop state
            end
        3'b100: // VerifyStop
            if (in) begin // stop bit detected
                nextState = 3'b011; // move to Done state
            end else begin
                nextState = 3'b100; // stay in VerifyStop state
            end
        3'b011: // Done
            nextState = 3'b001; // move back to Idle state
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state = 3'b001; // reset to Idle state
        done = 0;
    end else begin
        state = nextState;
        if (state == 3'b011) begin // Done state
            done = 1;
        end else begin
            done = 0;
        end
    end
end

endmodule