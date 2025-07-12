module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state; // 0 - IDLE, 1 - SEEN_1, 2 - SEEN_10
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if(x) next_state = 2'b01;
            else next_state = 2'b00;
            z = 1'b0;
        end
        2'b01: begin // SEEN_1
            if(x) next_state = 2'b01;
            else next_state = 2'b10;
            z = 1'b0;
        end
        2'b10: begin // SEEN_10
            if(x) begin
                next_state = 2'b01;
                z = 1'b1;
            end
            else next_state = 2'b00;
        end
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if(!aresetn) state <= 2'b00;
    else state <= next_state;
end

endmodule