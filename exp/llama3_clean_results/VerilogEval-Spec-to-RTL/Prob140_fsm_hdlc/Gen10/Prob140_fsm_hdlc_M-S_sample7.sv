module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;

localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TWO = 3'b010;
localparam THREE = 3'b011;
localparam FOUR = 3'b100;
localparam FIVE = 3'b101;
localparam SIX = 3'b110;
localparam SEVEN = 3'b111;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: state <= in ? ONE : IDLE;
            ONE: state <= in ? TWO : IDLE;
            TWO: state <= in ? THREE : IDLE;
            THREE: state <= in ? FOUR : IDLE;
            FOUR: state <= in ? FIVE : IDLE;
            FIVE: state <= in ? SIX : IDLE;
            SIX: state <= in ? SEVEN : IDLE;
            SEVEN: state <= in ? SEVEN : IDLE;
        endcase
    end
end

assign disc = (state == FIVE) && ~in;
assign flag = (state == SIX) && ~in;
assign err = (state == SEVEN) || (state == SIX && in);

endmodule