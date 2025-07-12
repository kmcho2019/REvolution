module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [2:0] state; // 3 bits to represent 8 states
reg [2:0] ones; // counter for consecutive 1s

localparam IDLE = 3'b000;
localparam ONES1 = 3'b001;
localparam ONES5 = 3'b101;
localparam FLAG = 3'b110;
localparam ERROR = 3'b111;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        ones <= 0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONES1;
                    ones <= 1;
                end
            end
            ONES1: begin
                if (in) begin
                    state <= ONES1;
                    ones <= ones + 1;
                    if (ones == 5) state <= ONES5;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                end
            end
            ONES5: begin
                if (in) begin
                    state <= FLAG;
                    ones <= ones + 1;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                    disc <= 1; // Discard bit after 5 consecutive ones
                end
            end
            FLAG: begin
                if (in) begin
                    state <= ERROR;
                    ones <= ones + 1;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                    flag <= 1; // Flag after 6 consecutive ones followed by 0
                end
            end
            ERROR: begin
                if (~in) begin
                    state <= IDLE;
                    ones <= 0;
                    err <= 0;
                end else begin
                    ones <= ones + 1;
                    err <= 1; // Error after 7 or more consecutive ones
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    disc <= 0;
    flag <= 0;
    err <= (state == ERROR);
end

endmodule