module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// State definitions
enum {A, B} state, nextState;

// Counters
reg [1:0] cycleCnt;
reg [1:0] wCnt;

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        state <= A;
        cycleCnt <= 0;
        wCnt <= 0;
    end else begin
        state <= nextState;
        if(nextState == B && cycleCnt == 0) begin
            cycleCnt <= 1;
            wCnt <= w ? 1 : 0;
        end else if(nextState == B) begin
            cycleCnt <= cycleCnt + 1;
            wCnt <= wCnt + (w ? 1 : 0);
        end else begin
            cycleCnt <= 0;
            wCnt <= 0;
        end
    end
end

// Combinatorial logic
always @(*) begin
    case(state)
        A: begin
            if(s) begin
                nextState = B;
            end else begin
                nextState = A;
            end
            z = 0; // z is only valid in state B after counting
        end
        B: begin
            if(cycleCnt < 3) begin
                nextState = B;
            end else begin
                nextState = B; // Remain in B to continuously check w
            end
            // Set z based on the count of w
            if(cycleCnt == 3) begin
                z = (wCnt == 2) ? 1 : 0;
            end else begin
                z = 0;
            end
        end
    endcase
end

endmodule