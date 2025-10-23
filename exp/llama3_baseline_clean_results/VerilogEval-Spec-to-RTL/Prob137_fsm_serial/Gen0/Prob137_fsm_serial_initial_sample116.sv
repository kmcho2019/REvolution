module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

// Enum for the states
enum logic [2:0] {IDLE, START, DATA, STOP} state, nextState;

// Register for the data bits
logic [7:0] dataReg;

// Counter for the bit position
logic [3:0] bitCnt;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        dataReg <= 8'd0;
        bitCnt <= 4'd0;
    end else begin
        state <= nextState;
        case (state)
            START: begin
                dataReg[0] <= in;
                bitCnt <= 1;
            end
            DATA: begin
                dataReg[bitCnt] <= in;
                bitCnt <= bitCnt + 1;
            end
            default: begin
                dataReg <= 8'd0;
                bitCnt <= 4'd0;
            end
        endcase
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (in == 0) begin
                nextState = START;
            end else begin
                nextState = IDLE;
            end
        end
        START: begin
            nextState = DATA;
        end
        DATA: begin
            if (bitCnt == 8) begin
                nextState = STOP;
            end else begin
                nextState = DATA;
            end
        end
        STOP: begin
            if (in == 1) begin
                nextState = IDLE;
            end else begin
                nextState = IDLE;
            end
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

assign done = (state == STOP) && in;
endmodule