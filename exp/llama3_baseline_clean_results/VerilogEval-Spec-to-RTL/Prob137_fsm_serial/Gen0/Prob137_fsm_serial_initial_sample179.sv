module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state;
reg [3:0] counter;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;  // IDLE state
        counter <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin  // IDLE state
                if (~in) begin  // Start bit detected
                    state <= 1;  // Transition to START state
                    counter <= 0;
                end
            end
            1: begin  // START state
                state <= 2;  // Transition to DATA state
            end
            2: begin  // DATA state
                counter <= counter + 1;
                if (counter == 8) begin
                    state <= 3;  // Transition to STOP state
                end
            end
            3: begin  // STOP state
                if (in) begin  // Stop bit received
                    state <= 0;  // Transition back to IDLE state
                    done <= 1;
                end
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (state == 0 && done) begin
        done <= 0;
    end
end

endmodule