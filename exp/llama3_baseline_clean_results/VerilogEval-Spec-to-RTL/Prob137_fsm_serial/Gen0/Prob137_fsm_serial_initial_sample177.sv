module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state; // Idle, Start, Data, Stop
reg [2:0] nextState;
reg [7:0] data;
reg [2:0] counter;
reg done_reg;

always @(*) begin
    case(state)
        3'b000: begin // Idle
            if(in == 1'b0) begin // Start bit detected
                nextState = 3'b001; // Transition to Start state
            end else begin
                nextState = 3'b000; // Stay in Idle state
            end
        end
        3'b001: begin // Start
            nextState = 3'b010; // Transition to Data state
        end
        3'b010: begin // Data
            if(counter == 3'b111) begin // 8 data bits received
                nextState = 3'b011; // Transition to Stop state
            end else begin
                nextState = 3'b010; // Stay in Data state
            end
        end
        3'b011: begin // Stop
            if(in == 1'b1) begin // Stop bit detected
                nextState = 3'b000; // Transition to Idle state
                done_reg = 1'b1;
            end else begin
                nextState = 3'b011; // Stay in Stop state
            end
        end
        default: nextState = 3'b000;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000;
        counter <= 3'b000;
        data <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        state <= nextState;
        if(state == 3'b010) begin // Data state
            data <= {data[6:0], in}; // Shift data bits
            counter <= counter + 1'b1; // Increment counter
        end else begin
            counter <= 3'b000; // Reset counter
            data <= 8'b0; // Reset data
        end
        if(state == 3'b011 && in == 1'b1) begin // Stop state with stop bit
            done_reg <= 1'b1;
        end else begin
            done_reg <= 1'b0;
        end
    end
end

assign done = done_reg;

endmodule