module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // S0: 2'b00, S1: 2'b01, S2: 2'b10
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // S0
            if(x) 
                next_state = 2'b01; // '1' detected, go to S1
            else 
                next_state = 2'b00; // stay in S0
        end
        2'b01: begin // S1
            if(!x) 
                next_state = 2'b10; // '0' detected, go to S2
            else 
                next_state = 2'b01; // stay in S1
        end
        2'b10: begin // S2
            if(x) 
                next_state = 2'b01; // '1' detected, assert z, go to S1
            else 
                next_state = 2'b00; // '0' detected, go back to S0
        end
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        state <= 2'b00; // asynchronous reset
    end else begin
        state <= next_state;
    end
end

assign z = (state == 2'b10 && x); // assert z when '101' sequence detected

endmodule