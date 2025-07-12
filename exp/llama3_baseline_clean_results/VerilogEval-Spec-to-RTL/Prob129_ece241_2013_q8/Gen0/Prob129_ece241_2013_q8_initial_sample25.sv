module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state; // 0: IDLE, 1: SEEN_1, 2: SEEN_10
localparam IDLE = 2'b00;
localparam SEEN_1 = 2'b01;
localparam SEEN_10 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (x) begin
                    state <= SEEN_1;
                end
            end
            SEEN_1: begin
                if (!x) begin
                    state <= SEEN_10;
                end else begin
                    state <= SEEN_1;
                end
            end
            SEEN_10: begin
                if (x) begin
                    state <= SEEN_1;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: z = 0;
        SEEN_1: z = 0;
        SEEN_10: z = x;
    endcase
end

endmodule