module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states
reg [3:0] ones; // counter for consecutive 1s

localparam IDLE = 3'b000;
localparam ONES_SEQ = 3'b001;
localparam FLAG_SEQ = 3'b010;
localparam ERROR_SEQ = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        ones <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONES_SEQ;
                    ones <= 1;
                end
            end
            ONES_SEQ: begin
                if (in) begin
                    ones <= ones + 1;
                    if (ones == 5) state <= FLAG_SEQ;
                    else if (ones >= 7) state <= ERROR_SEQ;
                end else begin
                    state <= IDLE;
                end
            end
            FLAG_SEQ: begin
                if (~in) begin
                    state <= IDLE;
                end else begin
                    state <= ERROR_SEQ;
                end
            end
            ERROR_SEQ: begin
                if (~in) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign disc = (state == FLAG_SEQ && ones == 5);
assign flag = (state == IDLE && ones == 6);
assign err = (state == ERROR_SEQ);

endmodule