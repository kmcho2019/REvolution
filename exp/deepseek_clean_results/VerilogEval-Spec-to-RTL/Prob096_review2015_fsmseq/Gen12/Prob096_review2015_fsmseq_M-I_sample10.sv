module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] state;
    reg partial_match;
    reg found;

    // State encoding:
    // 000 - no match
    // 001 - '1'
    // 010 - '11'
    // 100 - '110'
    // Detection occurs when in '110' state and next bit is '1'

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            partial_match <= 1'b0;
            found <= 1'b0;
        end else if (!found) begin
            // First stage: partial match detection
            partial_match <= (state[1:0] == 2'b10) && (data == 1'b1);
            
            // Second stage: state transition
            case (state)
                3'b000: state <= data ? 3'b001 : 3'b000;
                3'b001: state <= data ? 3'b010 : 3'b000;
                3'b010: state <= data ? 3'b010 : 3'b100;
                3'b100: begin
                    if (data) begin
                        found <= 1'b1;
                        state <= 3'b000;
                    end else begin
                        state <= 3'b000;
                    end
                end
                default: state <= 3'b000;
            endcase
        end
    end

    assign start_shifting = found;

endmodule