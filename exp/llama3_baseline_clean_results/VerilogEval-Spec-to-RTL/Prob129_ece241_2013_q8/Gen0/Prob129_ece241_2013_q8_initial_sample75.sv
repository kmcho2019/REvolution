module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

parameter IDLE = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (x == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (x == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = S1;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(*) begin
    case (state)
        IDLE: begin
            if (x == 1'b1) begin
                z = 1'b0;
            end else begin
                z = 1'b0;
            end
        end
        S1: begin
            if (x == 1'b0) begin
                z = 1'b0;
            end else begin
                z = 1'b0;
            end
        end
        S2: begin
            if (x == 1'b1) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
        end
        default: z = 1'b0;
    endcase
end

endmodule