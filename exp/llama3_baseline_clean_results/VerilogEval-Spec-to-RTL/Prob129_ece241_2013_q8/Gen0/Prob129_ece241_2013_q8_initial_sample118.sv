module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

reg [1:0] state;
parameter IDLE = 2'b00, DETECT_1 = 2'b01, DETECT_10 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        case(state)
            IDLE: begin
                if (x) begin
                    state <= DETECT_1;
                end else begin
                    state <= IDLE;
                end
            end
            DETECT_1: begin
                if (~x) begin
                    state <= DETECT_10;
                end else begin
                    state <= DETECT_1;
                end
            end
            DETECT_10: begin
                if (x) begin
                    state <= DETECT_1;  // Return to DETECT_1 to recognize overlapping sequences
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

always @(*) begin
    case(state)
        IDLE: z = 1'b0;
        DETECT_1: z = 1'b0;
        DETECT_10: z = x;
    endcase
end

endmodule