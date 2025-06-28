module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// State declaration
parameter WAIT = 2'b00, ADD1 = 2'b01, OUTPUT = 2'b10;
reg [1:0] state, next_state;

// Shift register to store input bits
reg [7:0] shift_reg;
 
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= WAIT;
        z <= 0;
    end
    else begin
        state <= next_state;
        case(state)
            WAIT: begin
                next_state <= x ? ADD1 : WAIT;
                shift_reg <= {shift_reg[6:0], x};
            end
            ADD1: begin
                next_state <= OUTPUT;
                z <= (~shift_reg) + 1;
            end
            OUTPUT: begin
                next_state <= WAIT;
            end
        endcase
    end
end

endmodule