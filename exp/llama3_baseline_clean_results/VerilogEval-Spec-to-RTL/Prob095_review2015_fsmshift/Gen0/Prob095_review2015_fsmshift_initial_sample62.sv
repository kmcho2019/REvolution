module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2-3: counter for shifting
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // idle state
            if(reset) begin
                next_state = 2'b01; // move to shifting state when reset
            end else begin
                next_state = 2'b00; // stay in idle state
            end
        end
        2'b01: begin // shifting state, cycle 1
            next_state = 2'b10; // move to cycle 2
        end
        2'b10: begin // shifting state, cycle 2
            next_state = 2'b11; // move to cycle 3
        end
        2'b11: begin // shifting state, cycle 3
            next_state = 2'b00; // move back to idle state
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b01; // synchronous reset
    end else begin
        state <= next_state;
    end
end

assign shift_ena = (state == 2'b01) || (state == 2'b10) || (state == 2'b11);

endmodule