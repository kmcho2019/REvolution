module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] current_state; // 1-bit register to hold the current state
reg [0:0] next_state; // 1-bit register to hold the next state
parameter OFF = 1'b0; // parameter to represent the OFF state
parameter ON = 1'b1; // parameter to represent the ON state

// output out is determined by the current state
assign out = current_state;

// combinational logic to determine the next state
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
        default: next_state = OFF; // default to OFF state
    endcase
end

// sequential logic to update the current state
always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        current_state <= OFF; // reset to OFF state
    end else begin
        current_state <= next_state;
    end
end

endmodule