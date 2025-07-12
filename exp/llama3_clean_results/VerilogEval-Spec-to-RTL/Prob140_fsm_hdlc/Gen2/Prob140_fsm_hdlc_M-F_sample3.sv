module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [2:0] state;
reg [2:0] nextState;

localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TWO = 3'b010;
localparam THREE = 3'b011;
localparam FOUR = 3'b100;
localparam FIVE = 3'b101;
localparam SIX = 3'b110;
localparam SEVEN = 3'b111;

always @(*) begin
    case(state)
        IDLE: begin
            if (in) begin
                nextState = ONE;
            end else begin
                nextState = IDLE;
            end
        end
        ONE: begin
            if (in) begin
                nextState = TWO;
            end else begin
                nextState = IDLE;
            end
        end
        TWO: begin
            if (in) begin
                nextState = THREE;
            end else begin
                nextState = IDLE;
            end
        end
        THREE: begin
            if (in) begin
                nextState = FOUR;
            end else begin
                nextState = IDLE;
            end
        end
        FOUR: begin
            if (in) begin
                nextState = FIVE;
            end else begin
                nextState = IDLE;
            end
        end
        FIVE: begin
            if (in) begin
                nextState = SIX;
            end else begin
                nextState = IDLE;
            end
        end
        SIX: begin
            if (in) begin
                nextState = SEVEN;
            end else begin
                nextState = IDLE;
            end
        end
        SEVEN: begin
            if (in) begin
                nextState = SEVEN;
            end else begin
                nextState = IDLE;
            end
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
        case(nextState)
            IDLE: begin
            end
            ONE: begin
            end
            TWO: begin
            end
            THREE: begin
            end
            FOUR: begin
            end
            FIVE: begin
                if (!in) begin
                    disc <= 1'b1;
                end
            end
            SIX: begin
                if (!in) begin
                    flag <= 1'b1;
                end
            end
            SEVEN: begin
                err <= 1'b1;
            end
            default: begin
            end
        endcase
    end
end

endmodule