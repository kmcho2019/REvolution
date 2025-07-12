module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 2-bit state register to store the current state
reg [1:0] nextState; // 2-bit next state register to store the next state

// Define the states
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(*) begin
    // Default next state is the current state
    nextState = state;

    case(state)
        IDLE: begin
            // If in[3] is 1, transition to BYTE1
            if(in[3] == 1'b1) begin
                nextState = BYTE1;
            end
        end
        BYTE1: begin
            // Transition to BYTE2
            nextState = BYTE2;
        end
        BYTE2: begin
            // Transition to BYTE3
            nextState = BYTE3;
        end
        BYTE3: begin
            // Transition back to IDLE
            nextState = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        // Reset to IDLE state
        state <= IDLE;
        done <= 1'b0;
    end else begin
        // Update state
        state <= nextState;
        
        // Check if we are in the BYTE3 state
        if(state == BYTE3) begin
            // Assert done
            done <= 1'b1;
        end else begin
            // Deassert done
            done <= 1'b0;
        end
    end
end

endmodule