module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 2-bit state register
reg [1:0] nextState; // 2-bit next state register

localparam IDLE = 2'b00;
localparam SEEN_1 = 2'b01;
localparam SEEN_10 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                nextState = SEEN_1;
            end else begin
                nextState = IDLE;
            end
            z = 1'b0;
        end
        SEEN_1: begin
            if (x) begin
                nextState = SEEN_1;
            end else begin
                nextState = SEEN_10;
            end
            z = 1'b0;
        end
        SEEN_10: begin
            if (x) begin
                nextState = SEEN_1;
                z = 1'b1;
            end else begin
                nextState = IDLE;
                z = 1'b0;
            end
        end
        default: begin
            nextState = IDLE;
            z = 1'b0;
        end
    endcase
end

endmodule