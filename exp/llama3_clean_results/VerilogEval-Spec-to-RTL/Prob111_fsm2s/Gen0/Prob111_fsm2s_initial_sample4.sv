module TopModule(clk, reset, j, k, out);
    input clk, reset, j, k;
    output out;
    reg out;

    // Define states
    parameter OFF = 1'b0, ON = 1'b1;
    reg current_state, next_state;

    // Output depends on the current state
    always @(current_state)
    begin
        case (current_state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
        endcase
    end

    // State transition logic
    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            case (current_state)
                OFF: 
                    if (j) 
                        current_state <= ON;
                    else 
                        current_state <= OFF;
                ON:  
                    if (k) 
                        current_state <= OFF;
                    else 
                        current_state <= ON;
            endcase
        end
    end
endmodule