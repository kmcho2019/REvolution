module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state, next_state;
reg [1:0] counter; // Counter for clock cycles
reg [1:0] w_count; // Counter for w = 1 occurrences

always @(*) begin
    case(state)
        2'b00: begin // State A
            if(s) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
            z = 0;
        end
        2'b01: begin // State B
            if(counter == 2'd2) begin // After three clock cycles
                if(w_count == 2'd2) begin // If w = 1 exactly twice
                    z = 1;
                end else begin
                    z = 0;
                end
                next_state = 2'b01; // Stay in B
            end else begin
                next_state = 2'b01; // Stay in B
                z = 0;
            end
        end
        default: begin
            next_state = 2'b00;
            z = 0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        counter <= 2'd0;
        w_count <= 2'd0;
    end else begin
        state <= next_state;
        if(state == 2'b00) begin
            counter <= 2'd0; // Reset counter in state A
            w_count <= 2'd0; // Reset w_count in state A
        end else if(counter == 2'd2) begin // After three clock cycles
            counter <= 2'd0; // Reset counter
            w_count <= 2'd0; // Reset w_count
        end else begin
            counter <= counter + 1; // Increment counter
            if(w) begin
                w_count <= w_count + 1; // Increment w_count if w = 1
            end
        end
    end
end

endmodule