module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end else begin
            case ({state, x})
                // State 000 transitions
                4'b0000: state <= 3'b000;  // x=0
                4'b0001: state <= 3'b001;  // x=1
                
                // State 001 transitions
                4'b0010: state <= 3'b001;  // x=0
                4'b0011: state <= {1'b1, 2'b00};  // x=1
                
                // State 010 transitions
                4'b0100: state <= 3'b010;  // x=0
                4'b0101: state <= 3'b001;  // x=1
                
                // State 011 transitions
                4'b0110: state <= 3'b001;  // x=0
                4'b0111: state <= 3'b010;  // x=1
                
                // State 100 transitions
                4'b1000: state <= {1'b0, state[1:0] + 1'b1};  // x=0 (011)
                4'b1001: state <= 3'b100;  // x=1
            endcase
        end
    end

    // Output is 1 when state is 011 or 100
    assign z = (state == 3'b011) | (state == 3'b100);

endmodule