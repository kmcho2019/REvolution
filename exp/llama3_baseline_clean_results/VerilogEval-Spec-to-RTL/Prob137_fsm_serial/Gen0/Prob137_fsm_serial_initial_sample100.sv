module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state;
reg [2:0] nextState;
reg [3:0] dataCounter;
reg [7:0] data;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE state
        dataCounter <= 0;
        done <= 0;
    end else begin
        case(state)
            0: begin // IDLE state
                if (!in) begin // Start bit detected
                    nextState <= 1; // Move to START_BIT state
                    dataCounter <= 0;
                end else begin
                    nextState <= 0; // Stay in IDLE state
                end
            end
            1: begin // START_BIT state
                nextState <= 2; // Move to DATA_BITS state
            end
            2: begin // DATA_BITS state
                dataCounter <= dataCounter + 1;
                data[7 - dataCounter + 1] <= in;
                if (dataCounter == 8) begin
                    nextState <= 3; // Move to STOP_BIT state
                end else begin
                    nextState <= 2; // Stay in DATA_BITS state
                end
            end
            3: begin // STOP_BIT state
                if (in) begin // Stop bit verified
                    nextState <= 0; // Move back to IDLE state
                    done <= 1; // Assert 'done' signal
                end else begin // Stop bit not verified
                    nextState <= 0; // Move back to IDLE state and wait for stop bit
                end
            end
        endcase
        
        // Update state at the next clock edge
        state <= nextState;
    end
end

// Reset 'done' signal at the next clock edge
always @ (posedge clk) begin
    if (!reset) begin
        if (state != 3 || !in) begin
            done <= 0;
        end
    end
end
endmodule