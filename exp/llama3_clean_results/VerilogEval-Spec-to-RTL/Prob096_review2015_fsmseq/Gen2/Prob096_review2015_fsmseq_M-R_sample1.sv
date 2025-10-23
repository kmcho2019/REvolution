module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam FOUND1 = 2'b01;
localparam FOUND11 = 2'b10;
localparam FOUND110 = 2'b11;
localparam FOUND1101 = 2'b00; // Reuse IDLE state for FOUND1101 to simplify logic

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= FOUND1;
                end
            end
            FOUND1: begin
                if (data) begin
                    state <= FOUND11;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND11: begin
                if (!data) begin
                    state <= FOUND110;
                end else begin
                    state <= FOUND1;
                end
            end
            FOUND110: begin
                if (data) begin
                    state <= FOUND1101; // Transition to FOUND1101 state
                    start_shifting <= 1; // Set start_shifting to 1
                end else begin
                    state <= IDLE;
                end
            end
            FOUND1101: begin
                // Remain in this state, keeping start_shifting = 1 until reset
            end
        endcase
    end
end

endmodule