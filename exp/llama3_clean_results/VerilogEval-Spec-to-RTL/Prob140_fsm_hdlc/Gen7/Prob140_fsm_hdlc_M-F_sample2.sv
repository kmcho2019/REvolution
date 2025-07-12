module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [2:0] state; // Simplified state machine
reg [2:0] ones; // Counter for consecutive ones

localparam IDLE = 3'b000;
localparam COUNTING = 3'b001;
localparam ERROR = 3'b100;

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
                    state <= COUNTING;
                    ones <= 1;
                end
            end
            COUNTING: begin
                if (in) begin
                    ones <= ones + 1;
                    if (ones >= 7) begin
                        state <= ERROR;
                    end
                end else begin
                    if (ones == 5) begin
                        disc <= 1; // Discard bit after 5 consecutive ones
                    end else if (ones == 6) begin
                        flag <= 1; // Flag after 6 consecutive ones
                    end
                    state <= IDLE;
                    ones <= 0;
                end
            end
            ERROR: begin
                if (~in) begin
                    state <= IDLE;
                    ones <= 0;
                end
                err <= 1; // Continue error state
            end
        endcase
    end
end

// Reset output signals on the next clock cycle
always @(posedge clk) begin
    if (~reset) begin
        if (state == IDLE || state == COUNTING) begin
            disc <= 0;
            flag <= 0;
        end
        if (state != ERROR) begin
            err <= 0;
        end
    end
end

endmodule