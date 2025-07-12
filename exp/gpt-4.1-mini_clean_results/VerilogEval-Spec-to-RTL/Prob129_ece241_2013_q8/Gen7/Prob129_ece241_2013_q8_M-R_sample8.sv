module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using parameters
    localparam S0 = 2'b00; // no bits matched
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (x) begin
                        next_state = S1;
                        z <= 1'b0;
                    end else begin
                        next_state = S0;
                        z <= 1'b0;
                    end
                end
                S1: begin
                    if (x) begin
                        next_state = S1;
                        z <= 1'b0;
                    end else begin
                        next_state = S2;
                        z <= 1'b0;
                    end
                end
                S2: begin
                    if (x) begin
                        next_state = S1;
                        z <= 1'b1; // sequence "101" detected on this cycle
                    end else begin
                        next_state = S0;
                        z <= 1'b0;
                    end
                end
                default: begin
                    next_state = S0;
                    z <= 1'b0;
                end
            endcase
            state <= next_state;
        end
    end

endmodule