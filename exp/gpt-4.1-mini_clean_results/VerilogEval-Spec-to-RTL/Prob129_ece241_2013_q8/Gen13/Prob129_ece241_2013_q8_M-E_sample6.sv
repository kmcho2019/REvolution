module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding (2-bit) using localparam for clarity
    localparam [1:0]
        IDLE = 2'b00,  // No match yet
        GOT1 = 2'b01,  // Matched '1'
        GOT10= 2'b10;  // Matched "10"

    reg [1:0] state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (x) begin
                        next_state = GOT1;
                        z <= 1'b0;
                    end else begin
                        next_state = IDLE;
                        z <= 1'b0;
                    end
                end

                GOT1: begin
                    if (~x) begin
                        next_state = GOT10;
                        z <= 1'b0;
                    end else begin
                        next_state = GOT1;
                        z <= 1'b0;
                    end
                end

                GOT10: begin
                    if (x) begin
                        next_state = GOT1;
                        z <= 1'b1;  // Sequence "101" detected here
                    end else begin
                        next_state = IDLE;
                        z <= 1'b0;
                    end
                end

                default: begin
                    next_state = IDLE;
                    z <= 1'b0;
                end
            endcase

            state <= next_state;
        end
    end

endmodule