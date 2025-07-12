module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// Define states
localparam IDLE = 2'b00;
localparam SEEN_1 = 2'b01;
localparam SEEN_10 = 2'b10;

always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1: begin
            if (x) begin
                next_state = SEEN_1;
            end else begin
                next_state = SEEN_10;
            end
        end
        SEEN_10: begin
            if (x) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE: z = 1'b0;
        SEEN_1: z = 1'b0;
        SEEN_10: z = x;
        default: z = 1'b0;
    endcase
end

endmodule