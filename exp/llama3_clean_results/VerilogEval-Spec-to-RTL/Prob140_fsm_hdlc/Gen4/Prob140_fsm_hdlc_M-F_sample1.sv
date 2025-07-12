module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [3:0] state; // 4 bits to represent 16 states
reg [3:0] ones; // counter for consecutive 1s

localparam IDLE = 4'b0000;
localparam ONES1 = 4'b0001;
localparam ONES2 = 4'b0010;
localparam ONES3 = 4'b0011;
localparam ONES4 = 4'b0100;
localparam ONES5 = 4'b0101;
localparam ONES6 = 4'b0110;
localparam FLAG = 4'b0111;
localparam ERROR = 4'b1000;

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
                    state <= ONES2;
                    ones <= ones + 1;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                end
            end
            ONES2: begin
                if (in) begin
                    state <= ONES3;
                    ones <= ones + 1;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                end
            end
            ONES3: begin
                if (in) begin
                    state <= ONES4;
                    ones <= ones + 1;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                end
            end
            ONES4: begin
                if (in) begin
                    state <= ONES5;
                    ones <= ones + 1;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                end
            end
            ONES5: begin
                if (in) begin
                    state <= ONES6;
                    ones <= ones + 1;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                    disc <= 1; // Discard bit after 5 consecutive ones
                end
            end
            ONES6: begin
                if (in) begin
                    state <= ERROR;
                    ones <= ones + 1;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                    flag <= 1; // Flag after 6 consecutive ones followed by 0
                end
            end
            FLAG: begin
                state <= IDLE;
                flag <= 0;
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

endmodule