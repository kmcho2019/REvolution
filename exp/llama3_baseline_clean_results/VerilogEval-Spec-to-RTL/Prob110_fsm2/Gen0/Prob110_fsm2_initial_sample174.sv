module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define the states
parameter OFF = 2'b00;
parameter ON  = 2'b01;

reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
assign out = (current_state == ON) ? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case (current_state)
        OFF: begin
            if (j == 1'b1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k == 1'b1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule