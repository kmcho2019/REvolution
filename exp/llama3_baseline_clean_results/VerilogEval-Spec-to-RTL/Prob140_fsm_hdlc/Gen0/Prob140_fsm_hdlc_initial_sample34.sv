module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits can represent 8 states (0 to 7)
localparam IDLE = 3'b000, ONE = 3'b001, TWO = 3'b010, THREE = 3'b011, FOUR = 3'b100, FIVE = 3'b101, DISC = 3'b110, FLAG = 3'b111, ERR = 3'b111;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in) state <= ONE;
                else state <= IDLE;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            ONE: begin
                if (in) state <= TWO;
                else state <= IDLE;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            TWO: begin
                if (in) state <= THREE;
                else state <= IDLE;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            THREE: begin
                if (in) state <= FOUR;
                else state <= IDLE;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            FOUR: begin
                if (in) state <= FIVE;
                else state <= IDLE;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            FIVE: begin
                if (in) state <= DISC;
                else state <= IDLE;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            DISC: begin
                if (in) state <= ERR;
                else state <= IDLE;
                disc <= 1'b1;
                flag <= 1'b0;
                err <= 1'b0;
            end
            FLAG: begin
                if (in) state <= ERR;
                else state <= IDLE;
                disc <= 1'b0;
                flag <= 1'b1;
                err <= 1'b0;
            end
            ERR: begin
                if (in) state <= ERR;
                else state <= IDLE;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b1;
            end
        endcase
        if (state == FIVE && in) state <= FLAG;
    end
end

endmodule