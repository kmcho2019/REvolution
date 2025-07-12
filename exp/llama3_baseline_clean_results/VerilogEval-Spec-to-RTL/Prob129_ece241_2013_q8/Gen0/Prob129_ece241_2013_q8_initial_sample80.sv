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
            if(x == 1) next_state = 1;
            else next_state = 0;
        end
        1: begin // seen_1
            if(x == 0) next_state = 2;
            else next_state = 1;
        end
        2: begin // seen_10
            if(x == 1) next_state = 1;
            else next_state = 0;
        end
        default: next_state = 0;
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) state <= 0;
    else state <= next_state;
end

assign z = (state == 2 && x == 1);

endmodule