module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state;
localparam IDLE = 3'b000;
localparam STATE_1 = 3'b001;
localparam STATE_11 = 3'b010;
localparam STATE_110 = 3'b011;
localparam STATE_1101 = 3'b100;

initial state = IDLE;

always @(*) begin
    case(state)
        IDLE: state = data ? STATE_1 : IDLE;
        STATE_1: state = data ? STATE_11 : IDLE;
        STATE_11: state = ~data ? STATE_110 : STATE_11;
        STATE_110: state = data ? STATE_1101 : IDLE;
        STATE_1101: state = STATE_1101;
        default: state = IDLE;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        if (state == STATE_1101) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule