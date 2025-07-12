module TopModule(
    input  clk,
    input  reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // IDLE state
            if(in[3]) begin
                nextState = 2'b01; // Move to BYTE1 state if in[3] = 1
            end else begin
                nextState = 2'b00; // Stay in IDLE state if in[3] = 0
            end
        end
        2'b01: begin // BYTE1 state
            nextState = 2'b10; // Move to BYTE2 state
        end
        2'b10: begin // BYTE2 state
            nextState = 2'b11; // Move to BYTE3 state
        end
        2'b11: begin // BYTE3 state
            nextState = 2'b00; // Move back to IDLE state
        end
        default: begin
            nextState = 2'b00; // Stay in IDLE state for any other state
        end
    endcase
end

assign done = (state == 2'b11); // Assert 'done' signal when in BYTE3 state

endmodule