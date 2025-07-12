module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [2:0] state; // 3 states for each part of the sequence plus the idle state
reg start_shifting_reg;

// Define the states
parameter Idle = 3'b000;
parameter GotFirstOne = 3'b001;
parameter GotSecondOne = 3'b010;
parameter GotZero = 3'b011;
parameter SequenceFound = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting_reg <= 1'b0;
    end else begin
        case (state)
            Idle: begin
                if (data) begin
                    state <= GotFirstOne;
                end else begin
                    state <= Idle;
                end
            end
            GotFirstOne: begin
                if (data) begin
                    state <= GotSecondOne;
                end else begin
                    state <= Idle;
                end
            end
            GotSecondOne: begin
                if (!data) begin
                    state <= GotZero;
                end else begin
                    state <= GotFirstOne;
                end
            end
            GotZero: begin
                if (data) begin
                    state <= SequenceFound;
                end else begin
                    state <= Idle;
                end
            end
            SequenceFound: begin
                state <= SequenceFound;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        start_shifting_reg <= 1'b0;
    end else if (state == SequenceFound) begin
        start_shifting_reg <= 1'b1;
    end
end

assign start_shifting = start_shifting_reg;

endmodule