module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state; // 3 states: idle (2'b00), seen1 (2'b01), seen10 (2'b10)
reg [1:0] next_state;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 2'b00; // idle state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // idle state
            if (x) begin
                next_state = 2'b01; // seen1 state
            end else begin
                next_state = 2'b00; // stay in idle state
            end
            z = 1'b0;
        end
        2'b01: begin // seen1 state
            if (~x) begin
                next_state = 2'b10; // seen10 state
            end else begin
                next_state = 2'b01; // stay in seen1 state
            end
            z = 1'b0;
        end
        2'b10: begin // seen10 state
            if (x) begin
                next_state = 2'b10; // stay in seen10 state
                z = 1'b1; // assert z
            end else begin
                next_state = 2'b10; // stay in seen10 state for overlapping sequences
                z = 1'b0;
            end
        end
        default: begin
            next_state = 2'b00; // idle state
            z = 1'b0;
        end
    endcase
end

endmodule