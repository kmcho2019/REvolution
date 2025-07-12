module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state; // 0: idle, 1: seen_1, 2: seen_10
reg [1:0] next_state;

always @(*) begin
    case(state)
        0: begin // idle
            if(x) begin
                next_state = 1; // seen_1
            end else begin
                next_state = 0; // stay in idle
            end
        end
        1: begin // seen_1
            if(x) begin
                next_state = 1; // stay in seen_1, sequence restarts
            end else begin
                next_state = 2; // seen_10
            end
        end
        2: begin // seen_10
            if(x) begin
                next_state = 1; // seen_1, sequence recognized, allow overlap
            end else begin
                next_state = 0; // idle, sequence not recognized
            end
        end
        default: next_state = 0; // default to idle
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 0; // Asynchronous reset
    end else begin
        state <= next_state;
    end
end

// Mealy output logic
assign z = (state == 2) && x;

endmodule