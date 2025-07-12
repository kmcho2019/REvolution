module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// Define the states
enum logic [1:0] {A, B, C} state, nextState;

// Counters
logic [1:0] cycleCnt;
logic [1:0] wCnt;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
        cycleCnt <= 2'b00;
        wCnt <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            A: begin
                if (s) begin
                    state <= B;
                    cycleCnt <= 2'b00;
                    wCnt <= 2'b00;
                end else begin
                    state <= A;
                end
                z <= 1'b0;
            end
            B: begin
                if (cycleCnt == 2'b11) begin // 3 cycles passed
                    state <= B;
                    cycleCnt <= 2'b00; // Reset cycle counter
                    z <= (wCnt == 2'b10); // Set z if wCnt is exactly 2
                    wCnt <= 2'b00; // Reset w counter
                end else begin
                    state <= B;
                    cycleCnt <= cycleCnt + 1'b1; // Increment cycle counter
                    wCnt <= wCnt + {1'b0, w}; // Increment w counter if w is 1
                end
            end
            default: state <= A;
        endcase
    end
end

endmodule