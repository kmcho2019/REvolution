module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // Counter to track consecutive ones
reg [1:0] state; // 2 bits to represent 4 states

localparam IDLE = 2'b00;
localparam ONES = 2'b01;
localparam SIX_ONES = 2'b10;
localparam ERROR = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        disc <= 0;
        flag <= 0;
        err <= 0;

        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONES;
                    count <= 1;
                end
            end
            ONES: begin
                if (in) begin
                    count <= count + 1;
                    if (count == 5) state <= SIX_ONES;
                    else if (count >= 7) state <= ERROR;
                end else begin
                    state <= IDLE;
                    if (count == 5) disc <= 1;
                end
            end
            SIX_ONES: begin
                if (in) begin
                    state <= ERROR;
                    err <= 1;
                end else begin
                    state <= IDLE;
                    flag <= 1;
                end
            end
            ERROR: begin
                if (~in) state <= IDLE;
                else err <= 1;
            end
        endcase
    end
end

endmodule