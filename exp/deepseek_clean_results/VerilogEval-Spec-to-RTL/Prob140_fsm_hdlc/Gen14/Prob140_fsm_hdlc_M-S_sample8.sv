module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [1:0] state;
    localparam IDLE     = 2'b00;
    localparam FIVE_ONES = 2'b01;
    localparam SIX_ONES = 2'b10;
    localparam ERROR    = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions and outputs
            case (state)
                IDLE: begin
                    if (in) state <= FIVE_ONES;
                end
                FIVE_ONES: begin
                    if (in) state <= SIX_ONES;
                    else begin
                        state <= IDLE;
                        disc <= 1;
                    end
                end
                SIX_ONES: begin
                    if (in) state <= ERROR;
                    else begin
                        state <= IDLE;
                        flag <= 1;
                    end
                end
                ERROR: begin
                    if (in) err <= 1;
                    else state <= IDLE;
                end
            endcase
        end
    end

endmodule