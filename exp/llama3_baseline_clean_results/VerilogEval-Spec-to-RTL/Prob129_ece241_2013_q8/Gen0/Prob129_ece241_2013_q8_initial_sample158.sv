module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
parameter IDLE = 2'b00;
parameter RCVD_1 = 2'b01;
parameter RCVD_10 = 2'b10;

reg [1:0] current_state;
reg [1:0] next_state;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            if (x) begin
                next_state <= RCVD_1;
            end else begin
                next_state <= IDLE;
            end
        end
        RCVD_1: begin
            if (~x) begin
                next_state <= RCVD_10;
            end else begin
                next_state <= RCVD_1;
            end
        end
        RCVD_10: begin
            if (x) begin
                next_state <= RCVD_1;
            end else begin
                next_state <= IDLE;
            end
        end
    endcase
end

always @(*) begin
    case (current_state)
        IDLE: z <= 0;
        RCVD_1: z <= 0;
        RCVD_10: z <= x;
    endcase
end

endmodule