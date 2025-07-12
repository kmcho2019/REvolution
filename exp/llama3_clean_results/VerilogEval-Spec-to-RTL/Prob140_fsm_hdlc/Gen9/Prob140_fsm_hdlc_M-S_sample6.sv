module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 6 states

localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TWO = 3'b010;
localparam THREE = 3'b011;
localparam FOUR = 3'b100;
localparam FIVE = 3'b101;
localparam SIX = 3'b110;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (in) state <= ONE;
                else state <= IDLE;
            end
            ONE: begin
                if (in) state <= TWO;
                else state <= IDLE;
            end
            TWO: begin
                if (in) state <= THREE;
                else state <= IDLE;
            end
            THREE: begin
                if (in) state <= FOUR;
                else state <= IDLE;
            end
            FOUR: begin
                if (in) state <= FIVE;
                else state <= IDLE;
            end
            FIVE: begin
                if (in) state <= SIX;
                else state <= IDLE;
            end
            SIX: begin
                if (in) state <= SIX; // error
                else state <= IDLE;
            end
        endcase
    end
end

assign disc = (state == FIVE) && ~in;
assign flag = (state == SIX) && ~in;
assign err = (state == SIX) && in;

endmodule