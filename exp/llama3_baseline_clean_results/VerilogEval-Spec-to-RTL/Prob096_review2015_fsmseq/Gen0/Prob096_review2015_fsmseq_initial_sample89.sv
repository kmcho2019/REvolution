module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // 0: IDLE, 1: S1, 2: S2, 3: S3, 4: FOUND ( Note: Found is 4)
reg [1:0] nextState;
reg start_shifting_reg;

always @(*) begin
    case(state)
        0: begin // IDLE
            if(data == 1) begin
                nextState = 1; // Go to S1
                start_shifting_reg = 0;
            end
            else begin
                nextState = 0; // Stay in IDLE
                start_shifting_reg = 0;
            end
        end
        1: begin // S1
            if(data == 1) begin
                nextState = 2; // Go to S2
                start_shifting_reg = 0;
            end
            else if(data == 0) begin
                nextState = 0; // Go back to IDLE
                start_shifting_reg = 0;
            end
        end
        2: begin // S2
            if(data == 0) begin
                nextState = 3; // Go to S3
                start_shifting_reg = 0;
            end
            else begin
                nextState = 1; // Go back to S1
                start_shifting_reg = 0;
            end
        end
        3: begin // S3
            if(data == 1) begin
                nextState = 4; // Go to FOUND
                start_shifting_reg = 1;
            end
            else begin
                nextState = 0; // Go back to IDLE
                start_shifting_reg = 0;
            end
        end
        4: begin // FOUND
            nextState = 4; // Stay in FOUND
            start_shifting_reg = 1;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to IDLE
    end
    else begin
        state <= nextState; // Update state
    end
    start_shifting <= start_shifting_reg; // Update output
end

endmodule