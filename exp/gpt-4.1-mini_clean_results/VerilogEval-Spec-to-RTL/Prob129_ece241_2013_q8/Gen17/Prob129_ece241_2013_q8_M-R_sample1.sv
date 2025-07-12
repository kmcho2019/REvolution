module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    localparam S_IDLE = 2'd0;
    localparam S_1    = 2'd1;
    localparam S_10   = 2'd2;

    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            S_IDLE: begin
                if (x) begin
                    next_state = S_1;
                    z = 1'b0;
                end else begin
                    next_state = S_IDLE;
                    z = 1'b0;
                end
            end
            S_1: begin
                if (x) begin
                    next_state = S_1;
                    z = 1'b0;
                end else begin
                    next_state = S_10;
                    z = 1'b0;
                end
            end
            S_10: begin
                if (x) begin
                    next_state = S_1;
                    z = 1'b1;  // sequence "101" detected here
                end else begin
                    next_state = S_IDLE;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = S_IDLE;
                z = 1'b0;
            end
        endcase
    end

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule