module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states
    localparam IDLE  = 8'b00000001;
    localparam ONE   = 8'b00000010;
    localparam TWO   = 8'b00000100;
    localparam THREE = 8'b00001000;
    localparam FOUR  = 8'b00010000;
    localparam FIVE  = 8'b00100000;
    localparam SIX   = 8'b01000000;
    localparam ERROR = 8'b10000000;

    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs (only set when conditions met)
            disc <= 0;
            flag <= 0;
            err <= 0;

            case (state)
                IDLE: begin
                    if (in) state <= ONE;
                end
                ONE: begin
                    if (in) state <= TWO;
                    else state <= IDLE;
                end
                TWO: begin
                    if (in) state <= THREE;
                    else state <= IDLE;
                end
                THREE: begin
                    if (in) state <= FOUR;
                    else state <= IDLE;
                end
                FOUR: begin
                    if (in) state <= FIVE;
                    else state <= IDLE;
                end
                FIVE: begin
                    if (in) begin
                        state <= SIX;
                        disc <= ~in;  // Discard next bit if zero
                    end else begin
                        state <= IDLE;
                        disc <= 1;    // Discard after 5 ones
                    end
                end
                SIX: begin
                    if (in) begin
                        state <= ERROR;
                        err <= 1;     // Error on 7+ ones
                    end else begin
                        state <= IDLE;
                        flag <= 1;    // Flag on 6 ones + zero
                    end
                end
                ERROR: begin
                    if (!in) state <= IDLE;
                    err <= 1;         // Maintain error until reset
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule