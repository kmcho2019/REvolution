module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for each prefix of the target sequence using binary encoding
reg [2:0] state, next_state;

// Initialize the FSM to the IDLE state
initial state = 3'b000;

always @(*) begin
    case(state)
        3'b000: begin // IDLE
            if(data == 1'b1) begin
                next_state = 3'b001; // STATE_ end else begin
                next_state = 3'b000; // IDLE
            end
        end
        3'b001: begin // STATE_ if(data == 1'b1) begin
                next_state = 3'b010; // STATE_11
            end else begin
                next_state = 3'b000; // IDLE
            end
        end
        3'b010: begin // STATE_ if(data == 1'b0) begin
                next_state = 3'b011; // STATE_110
            end else begin
                next_state = 3'b010; // STATE_11
            end
        end
        3'b011: begin // STATE_110
            if(data == 1'b1) begin
                next_state = 3'b100; // STATE_            end else begin
                next_state = 3'b000; // IDLE
            end
        end
        3'b100: begin // STATE_            next_state = 3'b100; // STATE_        end
        default: next_state = 3'b000; // IDLE
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if(next_state == 3'b100) begin // STATE_110 start_shifting <= 1;
        end else if(state != 3'b100) begin // STATE_110 start_shifting <= 0;
        end
    end
end

endmodule