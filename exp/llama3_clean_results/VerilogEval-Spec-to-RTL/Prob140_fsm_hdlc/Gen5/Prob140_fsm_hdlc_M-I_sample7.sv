module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [2:0] state; // 3 bits to represent 8 states
reg [3:0] ones; // counter for consecutive 1s

localparam IDLE = 3'b000;
localparam ONES = 3'b001;
localparam FLAG_P = 3'b010; // Potential flag sequence
localparam ERROR = 3'b011;

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
                    state <= ONES;
                    ones <= 1;
                end
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            ONES: begin
                if (in) begin
                    ones <= ones + 1;
                    if (ones >= 7) state <= ERROR;
                    else if (ones == 6) state <= FLAG_P;
                end else if (ones == 5) begin
                    state <= IDLE;
                    disc <= 1; // Discard bit
                end else begin
                    state <= IDLE;
                    ones <= 0;
                end
            end
            FLAG_P: begin
                if (~in) begin
                    state <= IDLE;
                    flag <= 1; // Confirm flag sequence
                end else begin
                    state <= ERROR;
                end
            end
            ERROR: begin
                if (~in) begin
                    state <= IDLE;
                end
                err <= 1; // Error condition
            end
        endcase
    end
end

endmodule