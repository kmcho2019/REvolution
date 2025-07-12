module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

localparam IDLE = 2'b00;
localparam FIRST_ONE = 2'b01;
localparam SECOND_ONE = 2'b10;

always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = FIRST_ONE;
                z = 1'b0;
            end else begin
                next_state = IDLE;
                z = 1'b0;
            end
        end
        FIRST_ONE: begin
            if (~x) begin
                next_state = SECOND_ONE;
                z = 1'b0;
            end else begin
                next_state = FIRST_ONE;
                z = 1'b0;
            end
        end
        SECOND_ONE: begin
            if (x) begin
                next_state = FIRST_ONE;
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

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule