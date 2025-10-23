module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define the states
localparam IDLE = 2'b00;
localparam ONE_DETECTED = 2'b01;
localparam ZERO_ONE_DETECTED = 2'b10;

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
                next_state <= ONE_DETECTED;
                z <= 0;
            end else begin
                next_state <= IDLE;
                z <= 0;
            end
        end
        ONE_DETECTED: begin
            if (x) begin
                next_state <= ONE_DETECTED;
                z <= 0;
            end else begin
                next_state <= ZERO_ONE_DETECTED;
                z <= 0;
            end
        end
        ZERO_ONE_DETECTED: begin
            if (x) begin
                next_state <= ONE_DETECTED;
                z <= 1;
            end else begin
                next_state <= IDLE;
                z <= 0;
            end
        end
    endcase
end

endmodule