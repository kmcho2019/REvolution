module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [1:0] current_state;
reg [1:0] next_state;

// Define states
parameter OFF = 2'b00;
parameter ON = 2'b01;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
always @(*) begin
    case (current_state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

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

endmodule