module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state, next_state;
localparam IDLE = 2'b00;
localparam SEQ_1 = 2'b01;
localparam SEQ_10 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if (x == 1'b1) begin
                next_state = SEQ_1;
                z = 1'b0;
            end else begin
                next_state = IDLE;
                z = 1'b0;
            end
        end
        SEQ_1: begin
            if (x == 1'b0) begin
                next_state = SEQ_10;
                z = 1'b0;
            end else if (x == 1'b1) begin
                next_state = SEQ_1;
                z = 1'b0;
            end
        end
        SEQ_10: begin
            if (x == 1'b1) begin
                next_state = SEQ_1;
                z = 1'b1;
            end else begin
                next_state = IDLE;
                z = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
            z = 1'b0;
        end
    endcase
end

endmodule