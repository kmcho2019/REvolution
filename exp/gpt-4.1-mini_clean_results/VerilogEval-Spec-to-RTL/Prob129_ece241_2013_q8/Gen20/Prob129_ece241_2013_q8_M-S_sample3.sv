module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    localparam IDLE = 2'b00, S1 = 2'b01, S10 = 2'b10;
    reg [1:0] state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (x) begin
                        next_state = S1;
                        z <= 1'b0;
                    end else begin
                        next_state = IDLE;
                        z <= 1'b0;
                    end
                end
                S1: begin
                    if (x) begin
                        next_state = S1;
                        z <= 1'b0;
                    end else begin
                        next_state = S10;
                        z <= 1'b0;
                    end
                end
                S10: begin
                    if (x) begin
                        next_state = S1;
                        z <= 1'b1;  // Sequence "101" detected
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