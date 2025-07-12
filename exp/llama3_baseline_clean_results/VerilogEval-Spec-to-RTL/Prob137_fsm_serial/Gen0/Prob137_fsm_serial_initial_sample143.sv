module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

    reg [2:0] state;
    reg [2:0] nextState;
    reg [7:0] data;
    reg [3:0] bitCount;
    reg [3:0] nextBitCount;

    // State Encoding
    localparam IDLE = 3'b000;
    localparam DATA = 3'b001;
    localparam STOP = 3'b010;
    localparam DONE = 3'b011;

    // Initialize state and bitCount
    initial begin
        state = IDLE;
        bitCount = 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bitCount <= 0;
            done <= 0;
        end else begin
            state <= nextState;
            bitCount <= nextBitCount;
            if (state == DONE) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 0) begin
                    nextState = DATA;
                    nextBitCount = 1;
                end else begin
                    nextState = IDLE;
                    nextBitCount = 0;
                end
            end
            DATA: begin
                if (bitCount == 8) begin
                    nextState = STOP;
                    nextBitCount = 0;
                end else begin
                    nextState = DATA;
                    nextBitCount = bitCount + 1;
                    data[7 - bitCount] = in;
                end
            end
            STOP: begin
                if (in == 1) begin
                    nextState = DONE;
                    nextBitCount = 0;
                end else begin
                    nextState = STOP;
                    nextBitCount = 0;
                end
            end
            DONE: begin
                nextState = IDLE;
                nextBitCount = 0;
            end
        endcase
    end

endmodule