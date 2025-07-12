module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // state register with 3 bits to represent 5 states

localparam IDLE = 3'b000;
localparam SEQ_1 = 3'b001;
localparam SEQ_11 = 3'b010;
localparam SEQ_110 = 3'b011;
localparam SEQ_1101 = 3'b100;

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= SEQ_1;
                end else begin
                    state <= IDLE;
                end
            end
            SEQ_1: begin
                if (data) begin
                    state <= SEQ_11;
                end else begin
                    state <= IDLE;
                end
            end
            SEQ_11: begin
                if (data) begin
                    state <= SEQ_1;
                end else begin
                    state <= SEQ_110;
                end
            end
            SEQ_110: begin
                if (data) begin
                    state <= SEQ_1101;
                end else begin
                    state <= IDLE;
                end
            end
            SEQ_1101: begin
                start_shifting <= 1;
                state <= SEQ_1101; // stay in this state until reset
            end
            default: begin
                state <= IDLE; // default to idle state
            end
        endcase
    end
end

endmodule