module TopModule(
    input        clk,
    input        reset,
    input        data,
    output reg   start_shifting
);

reg [1:0] state;

// States
localparam IDLE     = 2'b00;
localparam ONE      = 2'b01;
localparam ONE_ONE  = 2'b10;
localparam ONE_ONE_ZERO = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= ONE;
                end else begin
                    state <= IDLE;
                end
            end
            ONE: begin
                if (data) begin
                    state <= ONE_ONE;
                end else begin
                    state <= IDLE;
                end
            end
            ONE_ONE: begin
                if (!data) begin
                    state <= ONE_ONE_ZERO;
                end else begin
                    state <= ONE;
                end
            end
            ONE_ONE_ZERO: begin
                if (data) begin
                    state <= ONE;
                    start_shifting <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule