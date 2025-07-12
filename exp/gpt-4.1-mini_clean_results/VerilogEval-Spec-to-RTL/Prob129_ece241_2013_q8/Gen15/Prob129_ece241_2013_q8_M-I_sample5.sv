module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding with 2-bit states
    localparam S_IDLE = 2'd0;
    localparam S_1    = 2'd1;
    localparam S_10   = 2'd2;

    reg [1:0] state, next_state;

    // Next state and output logic combined for better optimization
    always @(*) begin
        case (state)
            S_IDLE: begin
                z = 1'b0;
                if (x)
                    next_state = S_1;
                else
                    next_state = S_IDLE;
            end
            S_1: begin
                z = 1'b0;
                if (x)
                    next_state = S_1;
                else
                    next_state = S_10;
            end
            S_10: begin
                z = x ? 1'b1 : 1'b0; // Output asserted only if x==1, sequence "101" detected
                next_state = x ? S_1 : S_IDLE;
            end
            default: begin
                z = 1'b0;
                next_state = S_IDLE;
            end
        endcase
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule