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
    localparam IDLE = 2'b00;
    localparam ONE = 2'b01;
    localparam TWO = 2'b10;
    localparam THREE = 2'b11;

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
                    if (in) begin
                        err <= 1;
                        state <= THREE;
                    end else begin
                        flag <= 1;
                        state <= IDLE;
                    end
                end
            endcase

            // Special case for disc output (after 5 ones)
            if (state == TWO && in) disc <= 1;
        end
    end

endmodule