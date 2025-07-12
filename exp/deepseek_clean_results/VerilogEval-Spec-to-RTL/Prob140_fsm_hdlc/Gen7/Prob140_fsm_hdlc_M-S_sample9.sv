module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [1:0] state;

    // State encoding
    localparam IDLE   = 2'b00;
    localparam ONE_1  = 2'b01;
    localparam FIVE_1 = 2'b10;
    localparam SIX_1  = 2'b11;

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

            // State transitions
            case (state)
                IDLE:   state <= in ? ONE_1 : IDLE;
                ONE_1:  state <= in ? FIVE_1 : IDLE;
                FIVE_1: begin
                    if (in) state <= SIX_1;
                    else disc <= 1;
                end
                SIX_1: begin
                    if (in) err <= 1;
                    else flag <= 1;
                    state <= in ? SIX_1 : IDLE;
                end
            endcase
        end
    end

endmodule