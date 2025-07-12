module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
reg [2:0] nextState;
reg discReg;
reg flagReg;
reg errReg;

// Encoding for states
localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TWO = 3'b010;
localparam THREE = 3'b011;
localparam FOUR = 3'b100;
localparam FIVE = 3'b101;
localparam SIX = 3'b110;
localparam SEVEN_OR_MORE = 3'b111;

// Output registers
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        discReg <= 0;
        flagReg <= 0;
        errReg <= 0;
    end else begin
        state <= nextState;
        discReg <= (state == FIVE && in == 0) ? 1 : 0;
        flagReg <= (state == SIX && in == 0) ? 1 : 0;
        errReg <= (state == SEVEN_OR_MORE) ? 1 : 0;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (in == 1) begin
                nextState = ONE;
            end else begin
                nextState = IDLE;
            end
        end
        ONE: begin
            if (in == 1) begin
                nextState = TWO;
            end else begin
                nextState = IDLE;
            end
        end
        TWO: begin
            if (in == 1) begin
                nextState = THREE;
            end else begin
                nextState = IDLE;
            end
        end
        THREE: begin
            if (in == 1) begin
                nextState = FOUR;
            end else begin
                nextState = IDLE;
            end
        end
        FOUR: begin
            if (in == 1) begin
                nextState = FIVE;
            end else begin
                nextState = IDLE;
            end
        end
        FIVE: begin
            if (in == 1) begin
                nextState = SIX;
            end else begin
                nextState = IDLE;
            end
        end
        SIX: begin
            if (in == 1) begin
                nextState = SEVEN_OR_MORE;
            end else begin
                nextState = IDLE;
            end
        end
        SEVEN_OR_MORE: begin
            if (in == 1) begin
                nextState = SEVEN_OR_MORE;
            end else begin
                nextState = IDLE;
            end
        end
        default: nextState = IDLE;
    endcase
end

assign disc = discReg;
assign flag = flagReg;
assign err = errReg;

endmodule